from parsecfg import loadConfig, getSectionValue
from std/json import `%`, `$`, parseJson, pretty, to

type
  JuryPayload* = object of RootObj
    name: string

  Jury = object of JuryPayload
    id: int32

  Vote* = object
    cosplayerId: int32
    juryId: int
    score: float32

proc readJuries* (): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "juries")

  return readFile(filePath)

proc writeJury* (jury: JuryPayload): void =
  var juries = readJuries().parseJson.to seq[Jury]
  
  juries.add(Jury(
    id: if juries.len == 0: 1 else: juries[juries.len - 1].id + 1,
    name: jury.name,
  ))

  var response = (%juries).pretty()
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "juries")

  writeFile(filePath, $response)

proc readVotes* (): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "votes")

  return readFile(filePath)


proc writeVote* (vote: Vote): void =
  var votes = readVotes().parseJson.to seq[Vote]

  votes.add(vote)

  var response = (%votes).pretty()
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "votes")

  writeFile(filePath, $response)
