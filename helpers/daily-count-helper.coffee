moment = require('moment')

exports.calculateKey = (key) ->
  "#{key}"
exports.dailyScoreKey = (key) ->
  dateKey = moment().format('YYYYMMDD')
  "#{key}:#{dateKey}"
exports.yesterdayScoreKey = (key) ->
  dateKey = moment().subtract(1, 'days').format('YYYYMMDD')
  "#{key}:#{dateKey}"
exports.dayOfWeekKey = (key, day) ->
  day = day.toLowerCase().replace(/'s|`s|s$/g, "")
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