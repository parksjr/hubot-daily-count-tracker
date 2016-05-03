Helper = require('hubot-test-helper')
expect = require('chai').expect
helper = new Helper('../src/hubot-daily-count-tracker.coffee')
keyHelper = require('../helpers/daily-count-helper.coffee')
moment = require('moment')
key = 'java'

describe 'hubot-daily-count-tracker-test', ->

  beforeEach ->
    @room = helper.createRoom(httpd: false)
    @room.robot.brain.data.countDailyTracker = {}
    @room.robot.brain.data.countDailyTracker[keyHelper.dailyScoreKey(key)] = 1
    @room.robot.brain.data.countDailyTracker[keyHelper.yesterdayScoreKey(key)] = 5
    @yesterday = moment().add('-1', 'days').format("dddd").toLowerCase()
    
  afterEach ->
    #@room.destroy() - isn't needed since we have the option httpd: false
  
  context 'user wants to retrieve today\'s count for ' + key, ->
    beforeEach ->
      @room.user.say 'danc', 'hubot get todays count for ' + key
      
    it 'should respond with today\'s count for' + key, ->
      expect(@room.messages).to.eql [
        ['danc', 'hubot get todays count for ' + key]
        ['hubot', 'Today\'s count for ' + key + ': 1']
      ]
  
  context 'user wants to retrieve yesterday\'s count for ' + key, ->
    beforeEach ->
      @room.user.say 'jarriett', 'hubot get yesterdays count for ' + key
    
    it 'should respond with yesterday\'s count for ' + key, ->
      expect(@room.messages).to.eql [
        ['jarriett', 'hubot get yesterdays count for ' + key]
        ['hubot', 'Yesterday\'s count for ' + key + ': 5']
      ]
  
  context 'user wants to retrieve monday\'s count for ' + key, ->
    beforeEach ->
      @room.user.say 'dans', 'hubot get mondays count for ' + key
    
    it 'should respond with monday\'s count for ' + key, ->
      if @yesterday == "monday"
        expect(@room.messages).to.eql [
          ['dans', 'hubot get mondays count for ' + key]
          ['hubot', 'mondays count for ' + key + ': 5']
        ]
      else
        expect(@room.messages).to.eql [
          ['dans', 'hubot get mondays count for ' + key]
          ['hubot', 'mondays count for ' + key + ': 0']
        ]
  
  context 'user wants to retrieve the highest recorded count for ' + key, ->
    beforeEach ->
      @room.user.say 'botbot', 'hubot get high score for ' + key
    
    it 'should respond with the highest recorded count for ' + key, ->
      expect(@room.messages).to.eql [
        ['botbot', 'hubot get high score for ' + key]
        ['hubot', 'Daily high score for ' + key + ': 5']
      ]