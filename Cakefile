async   = require "async"

cakepop = require "./cakepop.js"
pkg     = require "./package.json"
utils   = cakepop.utils
builder = new cakepop.CoffeeBuild()
style   = new cakepop.Style
  js:
    config: "dev/jshint.json"

CS_SOURCE = [
  "Cakefile"
  "cakepop.coffee"
]

JS_SOURCE = [
  "cakepop.js"
]

BUILD = [
  "cakepop.coffee"
]

codo = (cb) ->
  title = "CakePop v#{pkg.version}"
  utils.exec "codo -r README.md
                   -o doc
                   --title '#{title}'
                   cakepop.coffee -
                   HISTORY.md", cb

task "prepublish", "Run everything to get ready for publish.", ->
  async.series [
    (cb) -> style.coffeelint CS_SOURCE, cb
    (cb) -> builder.build BUILD, cb
    (cb) -> style.jshint JS_SOURCE, cb
    (cb) -> codo cb
  ], (err) ->
    utils.fail err if err
    utils.print "\nPrepublish finished successfully".info

task "dev:coffeelint", "Run CoffeeScript style checks.", ->
  style.coffeelint CS_SOURCE

task "dev:jshint", "Run JavaScript style checks.", ->
  style.jshint JS_SOURCE

task "source:build", "Build CoffeeScript to JavaScript.", ->
  builder.build BUILD

task "source:watch", "Watch (build) CoffeeScript to JavaScript.", ->
  builder.watch BUILD

task "docs:build", "Build CoffeeScript to JavaScript.", ->
  codo (err) ->
    utils.print err ? "\nDocuments finished building.".info
