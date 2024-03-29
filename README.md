# cosplayeval\_back

This is the back-end for [cosplayer\_evaluation](https://github.com/animegakuen/cosplayeval_front), containing all the logic for reading and writing data related to contestants in our events.

It is only missing image writing capabilities, which will be done in a later time.

## Running

Firstly you need `nim` installed, which I recommend using [`choosenim`](https://github.com/dom96/choosenim) for that. Once installed you can just `cd` into this project and run:

1. `nimble install -d` to install the dependencies of this project.
2. `nimble build -d:release` to build it in release form.
3. `./cosplayeval_back` to run the compiled binary.

By default it runs in port `5000` using `http` so you can do requests to `http://localhost:5000` (or whatever internal/public IP).

## Configuration

By changing [`api.cfg`](./api.cfg) you can change the path of where your cosplayer and vote data is stored, there are `JSON` files and are by default in `./data/cosplayers.json` and `./data/votes.json`.

# Endpoints

## GET `/cosplayers`

This returns you a _JSON_ with all the currently registered cosplayers, if none are registered it returns you an empty array (`[]`). Look at the `POST` description below for an interface of what you will receive.

## POST `/cosplayers`

You can use this endpoint to register a cosplayer in the event, here's a TypeScript interface of it:
```ts
interface CosplayerPayload {
  characterName: string
  images: string[]
  name: string
  nickname: string
  origin: string
  phoneNumber: string
}

interface Cosplayer extends CosplayerPayload {
  id: number // 32 bit integer.
}
```

As you can see, `CosplayerPayload` is what we expect to receive, while `Cosplayer` is what you will receive from sending a `GET` to the same endpoint.

## GET `/cosplayers/images/:id`

You can interact with this endpoint to retrieve images a cosplayer, these are based off of their ID in the json file containing the data from the cosplayers.

So if you have let's say:
```cfg
[Paths]
cosplayers = "./data/cosplayers.json"
cosplayerData = "./data/cosplayers"
```

And then request `http://localhost:5000/cosplayers/images/1`, that will read out the contents of `./data/cosplayers/1`, if that directory doesn't exists it will just return you an empty array.

## GET `/votes`

With this you can see all the jury votes, separated by each vote - can be very much improved later but for now, it is what it is. Look at the `POST` description below for an interface of what you will receive.

## POST `/votes`

This is what you use to register a jury's vote, there is no database so all these IDs are fictional so it is technically possible to register a vote for a cosplayer that doesn't exists.

Here's the interfaces in TypeScript:
```ts
interface Vote {
  cosplayerId: number // 32 bit integer.
  juryId: number // 32 bit integer.
  score: number // Internally a 32 bit float as scores should range from 0 to 10.
}
```
