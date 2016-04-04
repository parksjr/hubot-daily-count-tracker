# hubot-hubot-daily-count-tracker

A hubot script that does the things

See [`src/hubot-daily-count-tracker.coffee`](src/hubot-daily-count-tracker.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-daily-count-tracker --save`

Then add **hubot-daily-count-tracker** to your `external-scripts.json`:

```json
[
  "hubot-daily-count-tracker"
]
```

## Sample Interaction

```
user1>> java++
hubot>> java: 1
```
```
user1>> hubot get todays count java
hubot>> Today's count for java: 9
```
