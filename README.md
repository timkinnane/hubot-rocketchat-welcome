# hubot-rocketchat-welcome-dm
[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Dependency Status][daviddm-image]][daviddm-url] [![Coverage Status][coveralls-image]][coveralls-url]

Script to welcome new users via a DM from hubot

See [`src/rocketchat-welcome-dm.coffee`](src/rocketchat-welcome-dm.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-rocketchat-welcome-dm --save`

Then add **hubot-rocketchat-welcome-dm** to your `external-scripts.json`:

```json
["hubot-rocketchat-welcome-dm"]
```

## Sample Interaction

```
user1>> hubot hello
hubot>> hello!
```

[npm-url]: https://npmjs.org/package/hubot-rocketchat-welcome-dm
[npm-image]: http://img.shields.io/npm/v/hubot-rocketchat-welcome-dm.svg?style=flat
[travis-url]: https://travis-ci.org/Tim Kinnane/hubot-rocketchat-welcome-dm
[travis-image]: http://img.shields.io/travis/Tim Kinnane/hubot-rocketchat-welcome-dm/master.svg?style=flat
[daviddm-url]: https://david-dm.org/Tim Kinnane/hubot-rocketchat-welcome-dm.svg?theme=shields.io
[daviddm-image]: http://img.shields.io/david/Tim Kinnane/hubot-rocketchat-welcome-dm.svg?style=flat
[coveralls-url]: https://coveralls.io/r/Tim Kinnane/hubot-rocketchat-welcome-dm
[coveralls-image]: http://img.shields.io/coveralls/Tim Kinnane/hubot-rocketchat-welcome-dm/master.svg?style=flat
