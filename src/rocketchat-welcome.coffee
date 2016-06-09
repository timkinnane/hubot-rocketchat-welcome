# Description
#   Hubot script o welcome new users to Rocket.Chat or a Rocket.Chat room (via a DM as default)
#
# Configuration:
#   ROCKETCHAT_USER so the bot can introduce itself using its @username
#   WELCOME_MESSAGE what the bot says to new users
#   DIRECT_WELCOME Bool (default true) to welcome users by direct message, instead of posting in the room
#   GLOBAL_WELCOME Bool (default true) to welcome only once per user, false will welcome per once per user AND room
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
directWelcome = if process.env.DIRECT_WELCOME == 'true' then true else false
globalWelcome = if process.env.GLOBAL_WELCOME == 'true' then true else false
isDebug = if process.env.HUBOT_LOG_LEVEL == 'debug' then true else false

module.exports = (robot) ->

  welcoming = if globalWelcome then 'any new users' else 'new users in room'
  robot.logger.info "Welcome script is running, will send to #{ welcoming } saying:"
  robot.logger.info "\"#{ welcomeMessage }\""

  # get robot brain collection pointer when DB merged in
  robot.brain.on 'loaded', =>
    if robot.brain.get('welcomed_users') is null
      robot.brain.set 'welcomed_users', []

  # prepare user object for storing in brain
  # NB: userForId returns object of class User, but when persistent memory is saved/reloaded, it loses class
  # for that reason comparison fails and causes bug recognising users, so we remove the class from the beginning
  getUser = (msg) ->
    user = robot.brain.userForId msg.message.user.id, name: msg.message.user.name, room: msg.message.room
    return JSON.parse JSON.stringify user

  # determine if the user has been welcomed before
  # if global welcomes, matches on ID alone
  # otherwise, matches on whole user object so same user in different room will still be welcomed
  userIsKnown = (user) ->
    if globalWelcome
      found = (u for u in robot.brain.get 'welcomed_users' when u.id is user.id)[0]
    else
      found = (u for u in robot.brain.get 'welcomed_users' when u.id is user.id and u.room is user.room)[0]
    return typeof found is 'object'

  # store welcomed user in brain
  rememberUser = (user) ->
    unless userIsKnown user
      robot.brain.get('welcomed_users').push user
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
      welcomedUsers = robot.brain.get 'welcomed_users'
      if globalWelcome
        robot.brain.set 'welcomed_users', welcomedUsers.filter (u) -> not ( u.id is user.id )
      else
        robot.brain.set 'welcomed_users', welcomedUsers.filter (u) -> not ( u.id is user.id and u.room is user.room )
      robot.brain.save()
      msg.send if userIsKnown user then  "For some reason, I just can't forget you." else "Who said that?"

    # debug status of user in brain
    robot.respond /have we met/, (msg) ->
      if userIsKnown getUser msg
        msg.send "Yes #{ msg.message.user.name }, we've met, but you can instruct me to `say welcome` again."
      else
        msg.send "No #{ msg.message.user.name }, I don't believe we have. Please instruct me to `say welcome`."

    # debug entire brain in console
    robot.respond /brain dump/, (msg) ->
      console.log robot.brain.get 'welcomed_users'
