Helper = require('hubot-test-helper')
expect = require('chai').expect
helper = new Helper('../src/hubot-daily-count-tracker.coffee')
keyHelper = require('../helpers/daily-count-helper.coffee')
key = 'java'

describe 'hubot-count-test', ->
  
  beforeEach ->
    @room = helper.createRoom(httpd: false)
    @room.robot.brain.data.countTotal = {}
    @room.robot.brain.data.countTotal[keyHelper.calculateKey(key)] = 1
  
  afterEach ->
    #@room.destroy() - isn't needed since we have the option httpd: false
  
  context 'user wants increment the count for ' + key, ->
    beforeEach ->
      @room.user.say 'allan', key + '++'
    
    it 'should increment and display the current count for ' + key, ->
      expect(@room.messages).to.eql [
        ['allan', key + '++']
        ['hubot', key + ': 2']
      ]
    it 'should have ' + key + ' set to 2', ->
      expect(@room.robot.brain.data.countTotal[keyHelper.calculateKey(key)]).to.eql 2
  
  context 'user wants to decrement the count for ' + key, ->
    beforeEach ->
      @room.user.say 'todd', key + '--'
    
    it 'should decrement and display the current count for ' + key, ->
      expect(@room.messages).to.eql [
        ['todd', key + '--']
        ['hubot', key + ': 0']
      ]
    it 'should have ' + key + ' set to 0', ->
      expect(@room.robot.brain.data.countTotal[keyHelper.calculateKey(key)]).to.eql 0
  
  context 'user wants to retrieve the count for ' + key, ->
    beforeEach ->
      @room.user.say 'pat', 'hubot get count for ' + key
    
    it 'should respond with the current count for ' + key, ->
      expect(@room.messages).to.eql [
        ['pat', 'hubot get count for ' + key]
        ['hubot', key + ': 1']
      ]

  context 'user wants to reset the count for ' + key, ->
    beforeEach ->
      @room.user.say 'mike', 'hubot reset count ' + key
    
    it 'should respond with a count of 0 for ' + key, ->
      expect(@room.messages).to.eql [
        ['mike', 'hubot reset count ' + key]
        ['hubot', key + ': 0']
      ]
  
  context 'user wants to reset the count for a key that does not exist (i.e. \'poop\')', ->
    beforeEach ->
      @room.user.say 'botbot', 'hubot reset count poop'
    
    it 'should respond with \"There is no count for poop\"', ->
      expect(@room.messages).to.eql [
        ['botbot', 'hubot reset count poop']
        ['hubot', 'There is no count for poop']
      ]