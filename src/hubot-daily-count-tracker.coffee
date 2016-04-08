# Description:
#   This script allows hubot to count whenever you ++ or -- something, for example:
#      java++
#      java: 1
#   Also keeps track of daily usage which you can see, for example:
#      hubot get todays count java
#      Today's count for java is 1
#
# Commands:
#   hubot get count <item> - get the current full count of <item> you can increment with item++ and decrement with item--
#   hubot reset count <item> - resets the full count of <item> to 0
#   hubot get todays count <item> - shows today's count for <item>
#   hubot get yesterdays count <item> - shows yesterday's count for <item>
#   hubot get fridays count <item> - gets last Friday's count for <item>, exchange Friday for any day of the week
#
# Author:
#   Mike Parks <parks.jr@gmail.com>
moment = require('moment')
keyHelper = require('../helpers/daily-count-helper.coffee')
module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    robot.brain.data.countTotal ||= {}
    robot.brain.data.countDailyTracker ||= {}

  robot.hear /(\w+)\+\+/i, (res) ->
    key = res.match[1].trim().toLowerCase()

    value = robot.brain.data.countTotal[keyHelper.calculateKey(key)] ? 0
    value += 1
    dailyValue = robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] ? 0
    dailyValue += 1
    robot.brain.data.countTotal[keyHelper.calculateKey(key)] = value
    robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] = dailyValue
    res.send "#{key}: #{value}"

  robot.hear /(\w+)--/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countTotal[keyHelper.calculateKey(key)] ? 0
    value -= 1
    dailyValue = robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] ? 0
    dailyValue -= 1
    robot.brain.data.countTotal[keyHelper.calculateKey(key)] = value
    robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] = dailyValue
    res.send "#{key}: #{value}"

  robot.respond /get count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countTotal[keyHelper.calculateKey(key)] ? 0
    res.send "#{key}: #{value}"

  robot.respond /get today(?:'|`)?s count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] ? 0
    res.send "Today's count for #{key}: #{value}"

  robot.respond /get yesterday(?:'|`)?s count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countDailyTracker[keyHelper.yesterdayScoreKey(key)] ? 0
    res.send "Yesterday's count for #{key}: #{value}"

  robot.respond /get (?:last )?((?:mon|tue(?:s)?|wed(?:nes)?|thu(?:r)?(?:s)?|fri|sat|sun)(?:day)?(?:'s|`s|s)?) count (?:for )?(.*)/i, (res) ->
    key = res.match[2].trim().toLowerCase()
    day = res.match[1].trim().toLowerCase()
    today = moment().subtract(1, 'days')
    date = moment().day(day)
    if (date.isAfter(today))
      dayKey = keyHelper.dayOfWeekKey key, day
    else
      dayKey = "#{key}:" + date.format("YYYYMMDD")
    value = robot.brain.data.countDailyTracker[dayKey] ? 0
    res.send "#{day} count for #{key}: #{value}"

  robot.respond /get high score (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    data = robot.brain.data.countDailyTracker
    highest = 0
    for k,v of data
      if (k.indexOf(key) > -1)
        highest = v if v > highest
    res.send "Daily high score for #{key}: #{highest}"

  robot.respond /reset count (.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countTotal[keyHelper.calculateKey(key)]
    if value
      robot.brain.set(keyHelper.calculateKey(key), 0)
      res.send "#{key}: 0"
    else
      res.send "There is no count for #{key}"
  robot.respond /reset daily count tracker$/i, (res) ->
    delete robot.brain.data.countTotal
    delete robot.brain.data.countDailyTracker