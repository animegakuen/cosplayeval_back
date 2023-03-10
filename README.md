# cosplayer\_data

This is the back-end for [cosplayer\_evaluation](https://github.com/animegakuen/cosplayer_evaluation), containing all the logic for reading and writing data related to contestants in our events.

It is only missing image writing capabilities, which will be done in a later time.

## Running

Firstly you need `nim` installed, which I recommend using [`choosenim`](https://github.com/dom96/choosenim) for that. Once installed you can just `cd` into this project and run:

1. `nimble install` to install the dependencies of this project.
2. `nimble build -d:release` to build it in release form.
3. `./cosplayer_data` to run the compiled binary.

By default it runs in port `5000` using `http` so you can do requests to `http://localhost:5000` (or whatever internal/public IP).

# Endpoints

## GET `/cosplayers`

This returns you a _JSON_ with all the currently registered cosplayers, if none are registered it returns you an empty array (`[]`). Look at the `POST` description below for an interface of what you will receive.

## POST `/cosplayers`

You can use this endpoint to register a cosplayer in the event, here's a TypeScript interface of it:
```ts
interface CosplayerPayload {
  images: string[]
  name: string
  stageName: string
}

interface Cosplayer extends CosplayerPayload {
  id: number // 32 bit integer.
}
```

As you can see, `CosplayerPayload` is what we expect to receive, while `Cosplayer` is what you will receive from sending a `GET` to the same endpoint.

## GET `/juries`

This returns you a _JSON_ with all the currently registered juries, if none are registered it returns you an empty array (`[]`). Look at the `POST` description below for an interface of what you will receive.

## POST `/juries`

You can use this endpoint to register a jury judging the cosplayers, here's a TypeScript interface of it:
```ts
interface JuryPayload {
  name: string
}

interface Jury extends JuryPayload {
  id: number // 32 bit integer.
}
```

Like the `POST` in `/cosplayers`, `JuryPayload` is what we expect to receive while `Jury` is what you will receive when doing a `GET` request in the same endpoint.

## GET `/votes`

With this you can see all the jury votes, separated by each vote - can be very much improved later but for now, it is what it is. Look at the `POST` description below for an interface of what you will receive.

## POST `/votes`

This is what you use to register a jury's vote, you **can** use it even if a jury hasn't been registered yet. I decided to leave this to the front-end for now, having it make the decision to impede the user from submitting a vote if they haven't registered a jury yet.

Here's the interfaces in TypeScript:
```ts
interface Vote {
  cosplayerId: number // 32 bit integer.
  juryId: number // 32 bit integer.
  score: number // Internally a 32 bit float as scores should range from 0 to 10.
}
```
