#include "c74_min.h"
#include "zmqae/zmqae.h"

#include <string>
#include <unordered_map>
#include <unordered_set>

class zmqae_handler;

void handler_dispatch(void* user_data, zmqae_perform_ctx_t* ctx);

class zmqae_handler : public c74::min::object<zmqae_handler> {
public:
    MIN_DESCRIPTION{"Algebraic Effects handler (ZMQ ROUTER)"};
    MIN_TAGS{"network, zmq, algebraic effects"};
    MIN_AUTHOR{"zmq-algebraiceffect"};

    c74::min::attribute<c74::min::symbol> m_endpoint{this, "endpoint", "tcp://*:5555",
        c74::min::description{"ZMQ ROUTER bind endpoint"}};

    c74::min::outlet<> m_request_out{this, "<effect_name> <id> <json_payload>"};
    c74::min::outlet<> m_resume_out{this, "resume <id> <json_value> (echo)"};
    c74::min::outlet<> m_error_out{this, "(string) error message"};

    c74::min::message<> on_msg{this, "on", "Register effect handler",
        MIN_FUNCTION {
            if (args.empty()) {
                m_error_out.send("usage: on <effect_name>");
                return {};
            }
            if (!m_router) {
                m_error_out.send("not connected — send 'connect' first");
                return {};
            }
            auto effect = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            int rc = zmqae_router_on(m_router, effect.c_str(), handler_dispatch, this);
            if (rc == ZMQAE_OK) {
                m_registered.insert(effect);
                cout << "zmqae.handler: handler registered for " << effect << c74::min::endl;
            } else {
                m_error_out.send(std::string("on failed: ") + zmqae_last_error());
            }
            return {};
        }
    };

    c74::min::message<> off_msg{this, "off", "Unregister effect handler",
        MIN_FUNCTION {
            if (args.empty()) {
                m_error_out.send("usage: off <effect_name>");
                return {};
            }
            if (!m_router) return {};
            auto effect = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            zmqae_router_off(m_router, effect.c_str());
            m_registered.erase(effect);
            return {};
        }
    };

    c74::min::message<> resume_msg{this, "resume", "Resume a pending request (final)",
        MIN_FUNCTION {
            if (args.size() < 2) {
                m_error_out.send("usage: resume <id> <json_value>");
                return {};
            }
            auto id = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            auto json_value = std::string(static_cast<c74::min::symbol>(args[1]).c_str());

            auto it = m_pending.find(id);
            if (it == m_pending.end()) {
                m_error_out.send("no pending request with id: " + id);
                return {};
            }

            int rc = zmqae_ctx_resume(it->second, json_value.c_str());
            zmqae_ctx_release(it->second);
            m_pending.erase(it);

            if (rc != ZMQAE_OK) {
                m_error_out.send(std::string("resume failed: ") + zmqae_last_error());
                return {};
            }
            m_resume_out.send(c74::min::atoms{
                c74::min::symbol("resume"),
                c74::min::symbol(id.c_str()),
                c74::min::symbol(json_value.c_str())
            });
            return {};
        }
    };

    c74::min::message<> resume_partial_msg{this, "resumepartial", "Resume with intermediate (non-final) result",
        MIN_FUNCTION {
            if (args.size() < 2) {
                m_error_out.send("usage: resumepartial <id> <json_value>");
                return {};
            }
            auto id = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            auto json_value = std::string(static_cast<c74::min::symbol>(args[1]).c_str());

            auto it = m_pending.find(id);
            if (it == m_pending.end()) {
                m_error_out.send("no pending request with id: " + id);
                return {};
            }

            int rc = zmqae_ctx_resume_streaming(it->second, json_value.c_str(), 0); // 0 = not final

            if (rc != ZMQAE_OK) {
                m_error_out.send(std::string("resumepartial failed: ") + zmqae_last_error());
            }
            return {};
        }
    };

    c74::min::message<> setparent_msg{this, "setparent", "Set parent router endpoint for forwarding",
        MIN_FUNCTION {
            if (args.empty()) {
                m_error_out.send("usage: setparent <endpoint>");
                return {};
            }
            if (!m_router) {
                m_error_out.send("not connected — send 'connect' first");
                return {};
            }
            auto endpoint = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            int rc = zmqae_router_set_parent(m_router, endpoint.c_str());
            if (rc == ZMQAE_OK) {
                cout << "zmqae.handler: parent set to " << endpoint << c74::min::endl;
            } else {
                m_error_out.send(std::string("setparent failed: ") + zmqae_last_error());
            }
            return {};
        }
    };

    c74::min::message<> setnested_msg{this, "setnested", "Set nested endpoint for effect composition",
        MIN_FUNCTION {
            if (args.empty()) {
                m_error_out.send("usage: setnested <endpoint>");
                return {};
            }
            if (!m_router) {
                m_error_out.send("not connected — send 'connect' first");
                return {};
            }
            auto endpoint = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            int rc = zmqae_router_set_nested_endpoint(m_router, endpoint.c_str());
            if (rc == ZMQAE_OK) {
                cout << "zmqae.handler: nested endpoint set to " << endpoint << c74::min::endl;
            } else {
                m_error_out.send(std::string("setnested failed: ") + zmqae_last_error());
            }
            return {};
        }
    };

    c74::min::message<> bang_msg{this, "bang", "Poll for incoming requests",
        MIN_FUNCTION {
            do_poll();
            return {};
        }
    };

    c74::min::message<> connect_msg{this, "connect", "(Re)bind to endpoint",
        MIN_FUNCTION {
            do_close();
            do_connect();
            return {};
        }
    };

    c74::min::message<> close_msg{this, "close", "Close connection",
        MIN_FUNCTION {
            do_close();
            return {};
        }
    };

    c74::min::timer<c74::min::timer_options::defer_delivery> m_poll_timer{this,
        MIN_FUNCTION {
            if (m_router) {
                do_poll();
            }
            m_poll_timer.delay(10);
            return {};
        }
    };

    c74::min::timer<c74::min::timer_options::defer_delivery> m_init_timer{this,
        MIN_FUNCTION {
            do_connect();
            return {};
        }
    };

    zmqae_handler() {
        m_init_timer.delay(0);
    }

    ~zmqae_handler() {
        do_close();
    }

    friend void handler_dispatch(void*, zmqae_perform_ctx_t*);

    void on_perform(zmqae_perform_ctx_t* ctx);

private:
    void do_connect() {
        if (m_router) return;
        auto ep = std::string(m_endpoint.get().c_str());
        m_router = zmqae_router_new(ep.c_str());
        if (!m_router) {
            m_error_out.send(std::string("connect failed: ") + zmqae_last_error());
            return;
        }
        m_poll_timer.delay(10);
        cout << "zmqae.handler: bound to " << ep << c74::min::endl;
    }

    void do_close() {
        m_poll_timer.stop();
        for (auto& kv : m_pending) {
            zmqae_ctx_error(kv.second, "handler closed");
            zmqae_ctx_release(kv.second);
        }
        m_pending.clear();
        if (m_router) {
            zmqae_router_close(m_router);
            zmqae_router_destroy(m_router);
            m_router = nullptr;
        }
        m_registered.clear();
    }

    void do_poll() {
        if (!m_router) return;
        zmqae_router_poll(m_router);
    }

    zmqae_router_t* m_router{nullptr};
    std::unordered_set<std::string> m_registered;
    std::unordered_map<std::string, zmqae_perform_ctx_t*> m_pending;
};

MIN_EXTERNAL(zmqae_handler);

void zmqae_handler::on_perform(zmqae_perform_ctx_t* ctx) {
    auto id = std::string(zmqae_ctx_get_id(ctx));
    auto effect = std::string(zmqae_ctx_get_effect(ctx));
    auto payload = std::string(zmqae_ctx_get_payload(ctx));
    m_pending[id] = ctx;

    m_request_out.send(c74::min::atoms{
        c74::min::symbol(effect.c_str()),
        c74::min::symbol(id.c_str()),
        c74::min::symbol(payload.c_str())
    });
}

void handler_dispatch(void* user_data, zmqae_perform_ctx_t* ctx) {
    static_cast<zmqae_handler*>(user_data)->on_perform(ctx);
}
