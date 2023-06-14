from std/json import parseJson, to
import jester

from struct/Cosplayer import readCosplayers, writeCosplayer, CosplayerPayload
from struct/Jury import readJuries, writeJury, readVotes, writeVote, JuryPayload, Vote

proc setRoutes (request: Request): Future[ResponseData] {.async.} =
  block route:
    # get "/cosplayers":
    #   resp(Http200, @[("Access-Control-Allow-Origin", "*")], readCosplayers())

    # post "/cosplayers":
    #   try:
    #     writeCosplayer(request.body.parseJson.to CosplayerPayload)

    #     resp(Http200, @[("Access-Control-Allow-Origin", "*")], "OK")
    #   except:
    #     resp(Http500, "Invalid JSON payload.")

    # get "/juries":
    #   resp(Http200, @[("Access-Control-Allow-Origin", "*")], readJuries())

    # post "/juries":
    #   try:
    #     writeJury(request.body.parseJson.to JuryPayload)

    #     resp(Http200, @[("Access-Control-Allow-Origin", "*")], "OK")
    #   except:
    #     resp(Http500, "Invalid JSON payload.")

    # get "/votes":
    #   resp(Http200, @[
    #     ("Access-Control-Allow-Methods", "GET"), 
    #     ("Access-Control-Max-Age", "86400"), 
    #     ("Access-Control-Allow-Origin", "*")
    #   ], readVotes())

    # post "/votes":
    #   try:
    #     writeVote(request.body.parseJson.to Vote)

    #     resp(Http200, @[
    #       ("Access-Control-Allow-Methods", "POST"), 
    #       ("Access-Control-Allow-Headers", "Content-Type"), 
    #       ("Access-Control-Max-Age", "86400"), 
    #       ("Access-Control-Allow-Origin", "*")
    #     ], "OK")
    #   except:
    #     resp(Http500, "Invalid JSON payload.")
    
    case request.pathInfo
      of "/votes":
        case request.reqMethod
        of HttpPost:
          try:
            echo request.body

            writeVote(request.body.parseJson.to Vote)

            resp(Http200, @[
              ("Access-Control-Allow-Methods", "POST"), 
              ("Access-Control-Allow-Headers", "Content-Type"), 
              ("Access-Control-Max-Age", "86400"), 
              ("Access-Control-Allow-Origin", "*")
            ], "OK")
          except:
            resp(Http500, @[
              ("Access-Control-Allow-Methods", "POST"), 
              ("Access-Control-Allow-Headers", "Content-Type"), 
              ("Access-Control-Max-Age", "86400"), 
              ("Access-Control-Allow-Origin", "*")
            ], "Invalid JSON payload.")
        of HttpGet:
          resp(Http200, @[
            ("Access-Control-Allow-Methods", "POST"), 
            ("Access-Control-Allow-Headers", "Content-Type"), 
            ("Access-Control-Max-Age", "86400"), 
            ("Access-Control-Allow-Origin", "*")
          ], readVotes())
        of HttpOptions:
          resp(Http200, @[
            ("Access-Control-Allow-Methods", "POST"), 
            ("Access-Control-Allow-Headers", "Content-Type"), 
            ("Access-Control-Max-Age", "86400"), 
            ("Access-Control-Allow-Origin", "*")
          ], "OK")
        else:
          resp Http400, "Not found"
      else:
        resp Http400, "Not found"


when isMainModule:
  var server = initJester(setRoutes, newSettings(bindAddr = "192.168.138.233"))
  server.serve()
