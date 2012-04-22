async   = require "async"
colors  = require "colors"

cakepop = require "./cakepop.js"
utils   = cakepop.utils
style   = new cakepop.Style()
builder = new cakepop.CoffeeBuild()

SOURCE = [
  "Cakefile"
  "cakepop.coffee"
]

BUILD = [
  "cakepop.coffee"
]

task "dev:prepublish", "Run everything to get ready for publish.", ->
  async.series [
    (cb) -> style.coffeelint SOURCE, cb
    (cb) -> builder.build BUILD, cb
    (cb) -> cakepop.utils.exec "codo -r README.md -o doc cakepop.coffee", cb
  ], (err) ->
    utils.fail err if err
    utils.print "Done".info

task "dev:coffeelint", "Run CoffeeScript style checks.", ->
  style.coffeelint SOURCE

task "source:build", "Build CoffeeScript to JavaScript.", ->
  builder.build BUILD

task "source:watch", "Watch (build) CoffeeScript to JavaScript.", ->
  builder.watch BUILD

task "docs:build", "Build CoffeeScript to JavaScript.", ->
  utils.exec "codo -r README.md -o doc cakepop.coffee"
