Daily Count Tracker for Hubot
=========

A hubot script that gives users the ability to count an item using ++ or -- appeneded. Daily count data is tracked and can be used with other commands in this script, as well as the ability to mine the data in a companion web application that would share the same hubot persistence such as redis to go.

## Installation

  npm install hubot-daily-count-tracker --save

## Usage

  user:
    java++
  hubot:
    java: 1


  user:
    hubot get todays count java
  hubot:
    Today's count for java: 1

## Release History

* 0.1.0 Initial release