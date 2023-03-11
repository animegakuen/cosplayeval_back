from std/json import parseJson, to
import jester

from struct/Cosplayer import readCosplayers, writeCosplayer, CosplayerPayload
from struct/Jury import readJuries, writeJury, readVotes, writeVote, JuryPayload, Vote

proc setRoutes (): void =
  routes:
    get "/cosplayers":
      resp(Http200, @[("Access-Control-Allow-Origin", "*")], readCosplayers())

    post "/cosplayers":
      try:
        writeCosplayer(request.body.parseJson.to CosplayerPayload)

        resp(Http200, @[("Access-Control-Allow-Origin", "*")], "OK")
      except:
        resp(Http500, "Invalid JSON payload.")

    get "/juries":
      resp(Http200, @[("Access-Control-Allow-Origin", "*")], readJuries())

    post "/juries":
      try:
        writeJury(request.body.parseJson.to JuryPayload)

        resp(Http200, @[("Access-Control-Allow-Origin", "*")], "OK")
      except:
        resp(Http500, "Invalid JSON payload.")

    get "/votes":
      resp(Http200, @[("Access-Control-Allow-Origin", "*")], readVotes())

    post "/votes":
      try:
        writeVote(request.body.parseJson.to Vote)

        resp(Http200, @[("Access-Control-Allow-Origin", "*")], "OK")
      except:
        resp(Http500, "Invalid JSON payload.")

when isMainModule:
  setRoutes()
