from os import walkDir, splitFile, joinPath
from parsecfg import loadConfig, getSectionValue
from std/json import `%`, `$`, parseJson, pretty, to

type
  CosplayerPayload* = object of RootObj
    characterName: string
    images: seq[string]
    name: string
    nickname: string
    phoneNumber: string

  Cosplayer = object of CosplayerPayload
    id: int32

proc readCosplayers* (): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "cosplayers")

  return readFile(filePath)

proc writeCosplayer* (cosplayer: CosplayerPayload): void =
  echo "D:"
  var cosplayers = readCosplayers().parseJson.to seq[Cosplayer]
  echo ":)"
  
  cosplayers.add(Cosplayer(
    id: if cosplayers.len == 0: 1 else: cosplayers[cosplayers.len - 1].id + 1,
    characterName: cosplayer.characterName,
    images: cosplayer.images,
    name: cosplayer.name,
    nickname: cosplayer.nickname,
    phoneNumber: cosplayer.phoneNumber,
  ))
  echo ":o"

  var response = (%cosplayers).pretty()
  echo "B)"

  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "cosplayers")
  writeFile(filePath, $response)

proc readCosplayerImages* (id: string): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "cosplayerData")

  var files: seq[string]

  for kind, path in walkDir joinPath(filePath, id):
    files.add(path)

  return (%files).pretty()

