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
    "rect" : [100.0, 100.0, 800.0, 800.0],
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
    "description" : "zmqae.performer — Algebraic Effects performer (ZMQ DEALER client)",
    "digest" : "Send algebraic effect perform requests and receive results via ZMQ",
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
          "text" : "zmqae.performer"
        }
      },
      {
        "box" : {
          "id" : "obj-2",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 55.0, 600.0, 20.0],
          "text" : "Algebraic Effects performer — sends perform requests via ZMQ DEALER"
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
          "patching_rect" : [50.0, 125.0, 450.0, 20.0],
          "text" : "@endpoint (symbol): ZMQ DEALER connect endpoint (default: tcp://localhost:5555)"
        }
      },
      {
        "box" : {
          "id" : "obj-5",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 150.0, 400.0, 20.0],
          "text" : "@timeout (int): Timeout in ms, 0 = blocking (default: 0)"
        }
      },
      {
        "box" : {
          "id" : "obj-6",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 190.0, 150.0, 20.0],
          "text" : "--- Messages ---"
        }
      },
      {
        "box" : {
          "id" : "obj-7",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 215.0, 400.0, 20.0],
          "text" : "connect: (Re)connect to endpoint"
        }
      },
      {
        "box" : {
          "id" : "obj-8",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 240.0, 400.0, 20.0],
          "text" : "disconnect / close: Close connection"
        }
      },
      {
        "box" : {
          "id" : "obj-9",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 265.0, 500.0, 20.0],
          "text" : "perform <effect_name> <json_payload>: Send an algebraic effect request"
        }
      },
      {
        "box" : {
          "id" : "obj-10",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 290.0, 400.0, 20.0],
          "text" : "bang: Poll for pending results"
        }
      },
      {
        "box" : {
          "id" : "obj-11",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 330.0, 150.0, 20.0],
          "text" : "--- Outlets ---"
        }
      },
      {
        "box" : {
          "id" : "obj-12",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 355.0, 500.0, 20.0],
          "text" : "outlet 0 (left): result <id> <json_value> — perform result"
        }
      },
      {
        "box" : {
          "id" : "obj-13",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 380.0, 500.0, 20.0],
          "text" : "outlet 1 (right): error message (string)"
        }
      },
      {
        "box" : {
          "id" : "obj-14",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 430.0, 250.0, 20.0],
          "text" : "--- Example: Basic Perform ---"
        }
      },
      {
        "box" : {
          "id" : "obj-15",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", ""],
          "patching_rect" : [50.0, 470.0, 300.0, 22.0],
          "text" : "zmqae.performer @endpoint tcp://localhost:5555"
        }
      },
      {
        "box" : {
          "id" : "obj-16",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [50.0, 510.0, 350.0, 22.0],
          "text" : "perform Transcribe {\"text\":\"hello world\"}"
        }
      },
      {
        "box" : {
          "id" : "obj-17",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [420.0, 510.0, 80.0, 22.0],
          "text" : "connect"
        }
      },
      {
        "box" : {
          "id" : "obj-18",
          "maxclass" : "message",
          "numinlets" : 2,
          "numoutlets" : 1,
          "outlettype" : [""],
          "patching_rect" : [520.0, 510.0, 80.0, 22.0],
          "text" : "close"
        }
      },
      {
        "box" : {
          "id" : "obj-19",
          "maxclass" : "print",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 550.0, 100.0, 22.0],
          "text" : "result:"
        }
      },
      {
        "box" : {
          "id" : "obj-20",
          "maxclass" : "print",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [200.0, 550.0, 100.0, 22.0],
          "text" : "error:"
        }
      },
      {
        "box" : {
          "id" : "obj-21",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [50.0, 590.0, 250.0, 20.0],
          "text" : "--- Example: With Timeout ---"
        }
      },
      {
        "box" : {
          "id" : "obj-22",
          "maxclass" : "newobj",
          "numinlets" : 1,
          "numoutlets" : 2,
          "outlettype" : ["", ""],
          "patching_rect" : [50.0, 630.0, 350.0, 22.0],
          "text" : "zmqae.performer @endpoint tcp://localhost:5555 @timeout 5000"
        }
      },
      {
        "box" : {
          "id" : "obj-23",
          "maxclass" : "comment",
          "numinlets" : 1,
          "numoutlets" : 0,
          "patching_rect" : [420.0, 630.0, 300.0, 20.0],
          "text" : "5-second timeout per perform call"
        }
      }
    ],
    "lines" : [
      {
        "patchline" : {
          "source" : ["obj-16", 0],
          "destination" : ["obj-15", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-17", 0],
          "destination" : ["obj-15", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-18", 0],
          "destination" : ["obj-15", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-15", 0],
          "destination" : ["obj-19", 0]
        }
      },
      {
        "patchline" : {
          "source" : ["obj-15", 1],
          "destination" : ["obj-20", 0]
        }
      }
    ]
  }
}