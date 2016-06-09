# hubot-rocketchat-welcome
[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][daviddm-image]][daviddm-url] [![Coverage Status][coveralls-image]][coveralls-url]

Script to welcome new users via a DM from hubot

See [`src/rocketchat-welcome.coffee`](src/rocketchat-welcome.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-rocketchat-welcome --save`

Then add **hubot-rocketchat-welcome** to your `external-scripts.json`:

```json
["hubot-rocketchat-welcome"]
```

## Sample Interaction

```
user1>> hubot hello
hubot>> hello!
```

[npm-url]: https://npmjs.org/package/hubot-rocketchat-welcome
[npm-image]: http://img.shields.io/npm/v/hubot-rocketchat-welcome.svg?style=flat
[travis-url]: https://travis-ci.org/Tim Kinnane/hubot-rocketchat-welcome
[travis-image]: http://img.shields.io/travis/Tim Kinnane/hubot-rocketchat-welcome/master.svg?style=flat
[daviddm-url]: https://david.org/Tim Kinnane/hubot-rocketchat-welcome.svg?theme=shields.io
[daviddm-image]: http://img.shields.io/david/Tim Kinnane/hubot-rocketchat-welcome.svg?style=flat
[coveralls-url]: https://coveralls.io/r/Tim Kinnane/hubot-rocketchat-welcome
[coveralls-image]: http://img.shields.io/coveralls/Tim Kinnane/hubot-rocketchat-welcome/master.svg?style=flat
