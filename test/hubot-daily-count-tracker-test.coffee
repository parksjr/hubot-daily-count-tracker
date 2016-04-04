chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'hubot-daily-count-tracker', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/hubot-daily-count-tracker')(@robot)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith(/(\w+)\+\+/i)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith(/(\w+)--/i)
