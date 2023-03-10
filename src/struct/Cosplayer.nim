from parsecfg import loadConfig, getSectionValue
from std/json import `%`, `$`, parseJson, pretty, to

type
  CosplayerPayload* = object of RootObj
    images: seq[string]
    name: string
    stageName: string

  Cosplayer = object of CosplayerPayload
    id: int32

proc readCosplayers* (): string =
  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "cosplayers")

  return readFile(filePath)

proc writeCosplayer* (cosplayer: CosplayerPayload): void =
  var cosplayers = readCosplayers().parseJson.to seq[Cosplayer]
  
  cosplayers.add(Cosplayer(
    id: if cosplayers.len == 0: 1 else: cosplayers[cosplayers.len - 1].id + 1,
    images: cosplayer.images,
    name: cosplayer.name,
    stageName: cosplayer.stageName
  ))

  var response = (%cosplayers).pretty()

  var filePath = loadConfig("api.cfg").getSectionValue("Paths", "cosplayers")
  writeFile(filePath, $response)
