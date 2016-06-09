# hubot-rocketchat-welcome
[![NPM version][npm-image]][npm-url]

Hubot script to welcome new users to Rocket.Chat or a Rocket.Chat room (via a DM as default)

See [`src/rocketchat-welcome.coffee`](src/rocketchat-welcome.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-rocketchat-welcome --save`

Then add **hubot-rocketchat-welcome** to your `external-scripts.json`:

```json
["hubot-rocketchat-welcome"]
```

## Sample Interaction

User joins Rocket.Chat (and default room)
```
user1>> _Has joined the channel_
```
Hubot sends DM to welcome user
```
hubot>> Welcome, I'm @hubot. If you need help just reply with `help`
```

## Configuration

Set environment variables to change behavior

`WELCOME_MESSAGE` String, what the bot says to new users

`DIRECT_WELCOME` Bool (default true), welcome users by direct message, instead of posting in the room they joined

`GLOBAL_WELCOME` Bool (default true), welcome only once per user across all rooms, false will welcome once per room


[npm-url]: https://npmjs.org/package/hubot-rocketchat-welcome
[npm-image]: http://img.shields.io/npm/v/hubot-rocketchat-welcome.svg?style=flat
