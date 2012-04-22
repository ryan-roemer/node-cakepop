async   = require "async"

cakepop = require "./cakepop.js"
pkg     = require "./package.json"
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

codo = (cb) ->
  title = "CakePop v#{pkg.version}"
  utils.exec "codo -r README.md -o doc --title '#{title}' cakepop.coffee", cb

task "dev:prepublish", "Run everything to get ready for publish.", ->
  async.series [
    (cb) -> style.coffeelint SOURCE, cb
    (cb) -> builder.build BUILD, cb
    (cb) -> codo cb
  ], (err) ->
    utils.fail err if err
    utils.print "\nPrepublish finished successfully".info

task "dev:coffeelint", "Run CoffeeScript style checks.", ->
  style.coffeelint SOURCE

task "source:build", "Build CoffeeScript to JavaScript.", ->
  builder.build BUILD

task "source:watch", "Watch (build) CoffeeScript to JavaScript.", ->
  builder.watch BUILD

task "docs:build", "Build CoffeeScript to JavaScript.", ->
  codo (err) ->
    utils.print err ? "\nDocuments finished building.".info
