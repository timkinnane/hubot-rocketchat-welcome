# Description
#   Script to welcome new users via a DM from hubot
#
# Configuration:
#   ROCKETCHAT_USER so the bot can introduce itself using its @username
#   WELCOME_MESSAGE what the bot says to new users
#   GLOBAL_WELCOME true (default) to welcome only once per user, false will welcome per once per user AND room
#
# Commands:
#   hubot say welcome - Repeats the bot's welcome message.
#
# Notes:
#   TODO: Allow setting a welcome messsage by environment OR a command
#   TODO: Allow role authentication to decide who can set a new welcome message
#
# Author:
#   Tim Kinnane @ 4thParty

botName = process.env.ROCKETCHAT_USER or robot.name
welcomeMessage = process.env.WELCOME_MESSAGE or "Welcome, I'm @#{ botName }. If you need help, just reply with `help`"
globalWelcome = (process.env.GLOBAL_WELCOME == 'true') or true
isDebug = (process.env.HUBOT_LOG_LEVEL == 'debug') or false

module.exports = (robot) ->

  welcoming = if globalWelcome then 'any new users' else 'new users in room'
  robot.logger.info "Welcome-DM script is running, will send to #{ welcoming } saying:"
  robot.logger.info "\"#{ welcomeMessage }\""

  # get robot brain collection pointer when DB merged in
  robot.brain.on 'loaded', =>
    welcomedUsers = robot.brain.get('welcomed_users')
    if welcomedUsers is null
      robot.brain.set 'welcomed_users', []
      robot.logger.info "Welcome DMs haven't yet been sent to any users."
    else
      robot.logger.info "Welcome DMs already sent to #{ welcomedUsers.length } users."

  # prepare user object for storing in brain
  getUser = (msg) ->
    return robot.brain.userForId msg.message.user.id, name: msg.message.user.name, room: msg.message.room

  # determine if the user has been welcomed before
  # if global welcomes, matches on ID alone
  # otherwise, matches on whole user object so same user in different room will still be welcomed
  userIsKnown = (user) ->
    if globalWelcome
      found = (u for u in robot.brain.get('welcomed_users') when u.id is user.id)[0]
      console.log found, typeof found, typeof found is 'object'
      return typeof found is 'object'
    else
      return user in robot.brain.get('welcomed_users')

  # store welcomed user in brain
  rememberUser = (user) ->
    unless userIsKnown user
      robot.brain.get('welcomed_users').push user
    robot.brain.save()

  # forget we've ever met
  forgetUser = (user) ->
    if globalWelcome
      user = (u for u in robot.brain.get('welcomed_users') when u.id is user.id)[0]
      if typeof user is 'object'
        robot.brain.get('welcomed_users').splice user, 1
    else
      robot.brain.get('welcomed_users').splice user, 1
    robot.brain.save()

  # send welcome message if user unrecognized, or if forced
  welcomeUser = (msg, forced = false) ->
    user = getUser(msg)
    known = userIsKnown user
    if forced or not known
      msg.send welcomeMessage
      unless known
        rememberUser user

  # on user first entering a room with the bot
  # send direct message welcome and remember who it's sent to
  robot.enter (msg) ->
    welcomeUser msg
    console.log msg

  # reply (channel or DM) if forced to say welcome
  robot.respond /say welcome/, (msg) ->
    welcomeUser msg, true

  # register debug only listeners
  if (isDebug)

    # remove user from brain
    robot.respond /forget me/, (msg) ->
      user = getUser msg
      forgetUser user
      if userIsKnown user
        msg.send "For some reason, I just can't forget you."
      else
        msg.send "Who said that?"

    # debug status of user in brain
    robot.respond /have we met/, (msg) ->
      if userIsKnown getUser msg
        msg.send "Yes #{ msg.message.user.name }, we've met, but you can instruct me to `say welcome` again."
      else
        msg.send "No #{ msg.message.user.name }, I don't believe we have. Please instruct me to `say welcome`."

    # debug entire brain in console
    robot.respond /brain dump/, (msg) ->
      console.log robot.brain
