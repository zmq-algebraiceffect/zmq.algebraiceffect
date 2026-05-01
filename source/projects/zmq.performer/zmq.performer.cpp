#include "c74_min.h"
#include "zmqae/zmqae.h"

#include <string>

class zmq_performer;

static void performer_result_cb(void* user_data,
                                const char* id,
                                const char* json_value,
                                const char* error_message);

class zmq_performer : public c74::min::object<zmq_performer> {
public:
    MIN_DESCRIPTION{"Algebraic Effects performer (ZMQ DEALER client)"};
    MIN_TAGS{"network, zmq, algebraic effects"};
    MIN_AUTHOR{"zmq-algebraiceffect"};
    c74::min::attribute<c74::min::symbol> m_endpoint{this, "endpoint", "tcp://localhost:5555",
        c74::min::description{"ZMQ DEALER connect endpoint"}};
    c74::min::attribute<int> m_timeout{this, "timeout", 0,
        c74::min::description{"Timeout in ms (0 = blocking). Applied to perform calls."}};

    c74::min::outlet<> m_result_out{this, "(anything) result <id> <json_value>"};
    c74::min::outlet<> m_error_out{this, "(string) error message"};

    c74::min::message<> perform_msg{this, "perform", "Send an algebraic effect",
        MIN_FUNCTION {
            if (args.size() < 2) {
                m_error_out.send("usage: perform <effect_name> <json_payload>");
                return {};
            }
            if (!m_client) {
                m_error_out.send("not connected — send 'connect' first");
                return {};
            }
            auto effect = std::string(static_cast<c74::min::symbol>(args[0]).c_str());
            auto payload = std::string(static_cast<c74::min::symbol>(args[1]).c_str());
            int timeout_ms = static_cast<int>(m_timeout);

            int rc;
            if (timeout_ms > 0) {
                rc = zmqae_client_perform_timeout(m_client, effect.c_str(), payload.c_str(),
                                                  timeout_ms, performer_result_cb, this);
            } else {
                rc = zmqae_client_perform(m_client, effect.c_str(), payload.c_str(),
                                          performer_result_cb, this);
            }
            if (rc != ZMQAE_OK) {
                m_error_out.send(std::string("perform failed: ") + zmqae_last_error());
            }
            return {};
        }
    };

    c74::min::message<> bang_msg{this, "bang", "Poll for pending results",
        MIN_FUNCTION {
            do_poll();
            return {};
        }
    };

    c74::min::message<> connect_msg{this, "connect", "(Re)connect to endpoint",
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
            if (m_client) {
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

    zmq_performer() {
        m_init_timer.delay(0);
    }

    ~zmq_performer() {
        do_close();
    }

    friend void performer_result_cb(void*, const char*, const char*, const char*);

private:
    void do_connect() {
        if (m_client) return;
        auto ep = std::string(m_endpoint.get().c_str());
        m_client = zmqae_client_new(ep.c_str());
        if (!m_client) {
            m_error_out.send(std::string("connect failed: ") + zmqae_last_error());
            return;
        }
        m_poll_timer.delay(10);
        cout << "zmq.performer: connected to " << ep << c74::min::endl;
    }

    void do_close() {
        m_poll_timer.stop();
        if (m_client) {
            zmqae_client_close(m_client);
            zmqae_client_destroy(m_client);
            m_client = nullptr;
        }
    }

    void do_poll() {
        if (!m_client) return;
        zmqae_client_poll(m_client);
    }

    zmqae_client_t* m_client{nullptr};
};

MIN_EXTERNAL(zmq_performer);

static void performer_result_cb(void* user_data,
                                const char* id,
                                const char* json_value,
                                const char* error_message) {
    auto* obj = static_cast<zmq_performer*>(user_data);
    if (error_message) {
        obj->m_error_out.send(std::string(error_message));
    } else if (json_value) {
        obj->m_result_out.send(c74::min::atoms{
            c74::min::symbol("result"),
            c74::min::symbol(id),
            c74::min::symbol(json_value)
        });
    }
}
