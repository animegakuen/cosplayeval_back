import jester

from parsecfg import loadConfig, getSectionValue
from std/json import parseJson, to

from struct/Cosplayer import readCosplayers, writeCosplayer, readCosplayerImages, CosplayerPayload
from struct/Vote import readVotes, writeVote, VotePayload

## The headers we will be sending in every request.
const responseHeaders = @[
  ("Access-Control-Allow-Methods", "POST, GET, OPTIONS"), 
  ("Access-Control-Allow-Headers", "Content-Type"), 
  ("Access-Control-Max-Age", "86400"), 
  ("Access-Control-Allow-Origin", "*")
]

router customRouter:
  post "/votes":
    try:
      writeVote(request.body.parseJson.to VotePayload)

      resp(Http200, responseHeaders, "OK")
    except CatchableError:
      resp(Http500, responseHeaders, "Invalid JSON payload.")

  get "/votes":
    resp(Http200, responseHeaders, readVotes())

  options "/votes":
    resp(Http200, responseHeaders, "OK")

  post "/cosplayers":
    try:
      writeCosplayer(request.body.parseJson.to CosplayerPayload)

      resp(Http200, responseHeaders, "OK")
    except CatchableError:
      resp(Http500, responseHeaders, "Invalid JSON payload.")

  get "/cosplayers":
      resp(Http200, responseHeaders, readCosplayers())

  options "/cosplayers":
    resp(Http200, responseHeaders, "OK")

  get "/cosplayers/images/@id":
    var id = @"id"

    if id == "":
      resp(Http500, responseHeaders, "No id was provided.")
    else:
      resp(Http200, responseHeaders, readCosplayerImages(id))

  options "/cosplayers/images/@id":
    resp(Http200, responseHeaders, "OK")

when isMainModule:
  var ip = loadConfig("api.cfg").getSectionValue("Config", "ip")
  var server = initJester(customRouter, newSettings(bindAddr = ip))
  server.serve()
