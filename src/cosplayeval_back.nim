from std/json import parseJson, to
import jester

from struct/Cosplayer import readCosplayers, writeCosplayer, CosplayerPayload
from struct/Vote import readVotes, writeVote, VotePayload

## The headers we will be sending in every request.
const responseHeaders = @[
  ("Access-Control-Allow-Methods", "POST"), 
  ("Access-Control-Allow-Headers", "Content-Type"), 
  ("Access-Control-Max-Age", "86400"), 
  ("Access-Control-Allow-Origin", "*")
]

proc setRoutes (request: Request): Future[ResponseData] {.async.} =
  ## Sets all the routes to calls

  block route:
    case request.pathInfo:
      of "/votes":
        # Voting endpoint 
        case request.reqMethod:
          of HttpPost: # POST /votes
            try:
              writeVote(request.body.parseJson.to VotePayload)

              resp(Http200, responseHeaders, "OK")
            except:
              resp(Http500, responseHeaders, "Invalid JSON payload.")
          of HttpGet: # GET /votes
            resp(Http200, responseHeaders, readVotes())
          of HttpOptions: # OPTIONS /votes
            resp(Http200, responseHeaders, "OK")
          else:
            resp Http400, "Not found"
      of "/cosplayers":
        # Cosplayers endpoint
        case request.reqMethod:
          of HttpPost: # POST /cosplayers
            try:
              echo ">B)"
              echo request.body
              writeCosplayer(request.body.parseJson.to CosplayerPayload)
              echo ">BD"

              resp(Http200, responseHeaders, "OK")
            except:
              resp(Http500, responseHeaders, "Invalid JSON payload.")
          of HttpGet: # GET /cosplayers
            resp(Http200, responseHeaders, readCosplayers())
          of HttpOptions: # OPTIONS /cosplayers
            resp(Http200, responseHeaders, "OK")
          else:
            resp Http400, "Not found"
      else:
        resp Http400, "Not found"


when isMainModule:
  var server = initJester(setRoutes, newSettings(bindAddr = "127.0.0.1"))
  server.serve()
