cakepop = require "./cakepop.js"
style   = new cakepop.Style()
builder = new cakepop.CoffeeBuild()

SOURCE = [
  "Cakefile"
  "cakepop.coffee"
]

BUILD = [
  "cakepop.coffee"
]

task "dev:coffeelint", "Run CoffeeScript style checks.", ->
  style.coffeelint SOURCE

task "dev:build", "Build CoffeeScript to JavaScript.", ->
  builder.build BUILD

task "dev:watch", "Watch (build) CoffeeScript to JavaScript.", ->
  builder.watch BUILD
