from parsecfg import loadConfig, getSectionValue
from std/json import `%`, `$`, parseJson, pretty, to

type
  VotePayload* = object
    cosplayerId: int32
    juryName: string
    score: float32

proc readVotes* (): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "votes")

  return readFile(filePath)


proc writeVote* (vote: VotePayload): void =
  var votes = readVotes().parseJson.to seq[VotePayload]

  votes.add(vote)

  var response = (%votes).pretty()
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "votes")

  writeFile(filePath, $response)
