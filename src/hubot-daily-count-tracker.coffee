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
module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.countTotal ||= {}
    robot.brain.data.countDailyTracker ||= {}

  robot.hear /(\w+)\+\+/i, (res) ->
    key = res.match[1].trim().toLowerCase()

    value = robot.brain.data.countTotal[calculateKey(key)] ? 0
    value += 1
    dailyValue = robot.brain.data.countDailyTracker[dailyScoreKey(key)] ? 0
    dailyValue += 1
    robot.brain.data.countTotal[calculateKey(key)] = value
    robot.brain.data.countDailyTracker[dailyScoreKey(key)] = dailyValue
    res.send "#{key}: #{value}"

  robot.hear /(\w+)--/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countTotal[calculateKey(key)] ? 0
    value -= 1
    dailyValue = robot.brain.data.countDailyTracker[dailyScoreKey(key)] ? 0
    dailyValue -= 1
    robot.brain.data.countTotal[calculateKey(key)] = value
    robot.brain.data.countDailyTracker[dailyScoreKey(key)] = dailyValue
    res.send "#{key}: #{value}"

  robot.respond /get count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countTotal[calculateKey(key)] ? 0
    res.send "#{key}: #{value}"

  robot.respond /get today(?:'|`)?s count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countDailyTracker[dailyScoreKey(key)] ? 0
    res.send "Today's count for #{key}: #{value}"

  robot.respond /get yesterday(?:'|`)?s count (?:for )?(.*)/i, (res) ->
    key = res.match[1].trim().toLowerCase()
    value = robot.brain.data.countDailyTracker[yesterdayScoreKey(key)] ? 0
    res.send "Yesterday's count for #{key}: #{value}"

  robot.respond /get (?:last )?((?:mon|tue(?:s)?|wed(?:nes)?|thu(?:r)?(?:s)?|fri|sat|sun)(?:day)?)(?:'s|`s)? count (?:for )?(.*)/i, (res) ->
    key = res.match[2].trim().toLowerCase()
    day = res.match[1].trim().toLowerCase()
    today = moment().subtract(1, 'days')
    date = moment().day(day)
    if (date.isAfter(today))
      dayKey = dayOfWeekKey key, day
    else
      dayKey = "#{key}:" + date.format("YYYYMMDD")
    console.log key, day, today.format("MM/DD/YYYY"), date.format("MM/DD/YYYY")
    console.log dayKey

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
    value = robot.brain.data.countTotal[calculateKey(key)]
    if value
      robot.brain.set(calculateKey(key), 0)
      res.send "#{key}: 0"
    else
      res.send "There is no count for #{key}"
  robot.respond /reset daily count tracker$/i, (res) ->
    delete robot.brain.data.countTotal
    delete robot.brain.data.countDailyTracker

  calculateKey = (key) ->
    "#{key}"
  dailyScoreKey = (key) ->
    dateKey = moment().format('YYYYMMDD')
    "#{key}:#{dateKey}"
  yesterdayScoreKey = (key) ->
    dateKey = moment().subtract(1, 'days').format('YYYYMMDD')
    "#{key}:#{dateKey}"
  dayOfWeekKey = (key, day) ->
    day = day.toLowerCase()
    if day.indexOf("sun") > -1
      weekday = -7
    else if day.indexOf("mon") > -1
      weekday = -6
    else if day.indexOf("tue") > -1
      weekday = -5
    else if day.indexOf("wed") > -1
      weekday = -4
    else if day.indexOf("thu") > -1
      weekday = -3
    else if day.indexOf("fri") > -1
      weekday = -2
    else if  day.indexOf("sat") > -1
      weekday = -1
    dateKey = moment().weekday(weekday).format('YYYYMMDD')
    console.log day, weekday, dateKey
    "#{key}:#{dateKey}"