{
  "patcher" : {
    "fileversion" : 1,
    "appversion" : {
      "major" : 8,
      "minor" : 6,
      "revision" : 4,
      "processor" : "x86",
      "platform" : "macintel"
    },
    "classnamespace" : "box",
    "rect" : [100.0, 100.0, 900.0, 950.0],
    "bglocked" : 1,
    "openrect" : [0.0, 0.0, 0.0, 0.0],
    "openinpresentation" : 0,
    "default_fontsize" : 12.0,
    "default_fontface" : 0,
    "default_fontname" : "Arial",
    "gridonopen" : 2,
    "gridsize" : [15.0, 15.0],
    "gridsnaponopen" : 0,
    "objectsnaponopen" : 1,
    "statusbarvisible" : 2,
    "toolbarvisible" : 2,
    "lefttoolbarpinned" : 0,
    "toptoolbarpinned" : 0,
    "righttoolbarpinned" : 0,
    "bottomtoolbarpinned" : 0,
    "toolbars_unpinned_last_save" : 0,
    "tallnewobj" : 0,
    "boxanimatetime" : 200,
    "enablehscroll" : 1,
    "enablevscroll" : 1,
    "devicewidth" : 0.0,
    "description" : "zmqae.handler — Algebraic Effects handler (ZMQ ROUTER)",
    "digest" : "Handle algebraic effect requests, register handlers, and resume results via ZMQ",
    "tags" : "network, zmq, algebraic effects",
    "style" : "",
    "subpatcher_template" : "",
    "assistshowspatchername" : 0,
    "boxes" : [
      {
        "box" : {
          "id" : "obj-1",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 30.0, 400.0, 20.0],
          "text" : "zmqae.handler"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 55.0, 600.0, 20.0],
          "text" : "Algebraic Effects handler — receives perform requests via ZMQ ROUTER"
        }
      },
      {
        "box" : {
          "id" : "obj-3",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 100.0, 150.0, 20.0],
          "text" : "--- Attributes ---"
        }
      },
      {
        "box" : {
          "id" : "obj-4",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 125.0, 400.0, 20.0],
          "text" : "@endpoint (symbol): ZMQ ROUTER bind endpoint (default: tcp://*:5555)"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 160.0, 150.0, 20.0],
          "text" : "--- Messages ---"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 185.0, 400.0, 20.0],
          "text" : "connect: (Re)bind to endpoint"
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 210.0, 400.0, 20.0],
          "text" : "close: Close connection"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 235.0, 400.0, 20.0],
          "text" : "on <effect_name>: Register effect handler"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 260.0, 400.0, 20.0],
          "text" : "off <effect_name>: Unregister effect handler"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 285.0, 500.0, 20.0],
          "text" : "resume <id> <json_value>: Resume with final result"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 310.0, 500.0, 20.0],
          "text" : "resumepartial <id> <json_value>: Resume with intermediate (streaming) result"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 335.0, 400.0, 20.0],
          "text" : "setparent <endpoint>: Set parent router for effect forwarding"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 360.0, 400.0, 20.0],
          "text" : "setnested <endpoint>: Set nested perform endpoint"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 385.0, 400.0, 20.0],
          "text" : "bang: Poll for incoming requests"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 420.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 445.0, 500.0, 20.0],
          "text" : "outlet 0 (left): <effect_name> <id> <json_payload> — incoming perform request"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 470.0, 500.0, 20.0],
          "text" : "outlet 1 (middle): resume <id> <json_value> — resume echo"
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 495.0, 500.0, 20.0],
          "text" : "outlet 2 (right): error message (string)"
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 540.0, 300.0, 20.0],
          "text" : "--- Example: Register Handler & Resume ---"
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 3,
          "outlettype" : ["", "", ""],
          "patching_rect" : [50.0, 580.0, 250.0, 22.0],
          "text" : "zmqae.handler @endpoint tcp://*:5555"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 620.0, 120.0, 22.0],
          "text" : "on Transcribe"
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [190.0, 620.0, 100.0, 22.0],
          "text" : "connect"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [310.0, 620.0, 80.0, 22.0],
          "text" : "close"
        }
      },
      {
        "box" : {
          "id" : "obj-24",
          "maxclass" : "print",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 660.0, 120.0, 22.0],
          "text" : "request:"
        }
      },
      {
        "box" : {
          "id" : "obj-25",
          "maxclass" : "print",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [200.0, 660.0, 110.0, 22.0],
          "text" : "resume-echo:"
        }
      },
      {
        "box" : {
          "id" : "obj-26",
          "maxclass" : "print",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [340.0, 660.0, 100.0, 22.0],
          "text" : "error:"
        }
      },
      {
        "box" : {
          "id" : "obj-27",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 700.0, 300.0, 20.0],
          "text" : "--- Example: Resume with Result ---"
        }
      },
      {
        "box" : {
          "id" : "obj-28",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 740.0, 350.0, 22.0],
          "text" : "resume abc123 {\"text\":\"processed\"}"
        }
      },
      {
        "box" : {
          "id" : "obj-29",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [420.0, 740.0, 300.0, 20.0],
          "text" : "Replace abc123 with actual id from outlet 0"
        }
      },
      {
        "box" : {
          "id" : "obj-30",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 780.0, 300.0, 20.0],
          "text" : "--- Example: Set Parent & Nested ---"
        }
      },
      {
        "box" : {
          "id" : "obj-31",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 820.0, 280.0, 22.0],
          "text" : "setparent tcp://localhost:5556"
        }
      },
      {
        "box" : {
          "id" : "obj-32",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [360.0, 820.0, 280.0, 22.0],
          "text" : "setnested tcp://localhost:5557"
        }
      }
    ],
    "lines" : [
      {
        "patchline" : {
          "source" : ["obj-21", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-22", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-23", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-28", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-31", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-32", 0],
          "destination" : ["obj-20", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 0],
          "destination" : ["obj-24", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 1],
          "destination" : ["obj-25", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-20", 2],
          "destination" : ["obj-26", 0]
        }
      }
    ]
  }
}