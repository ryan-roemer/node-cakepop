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

task "source:build", "Build CoffeeScript to JavaScript.", ->
  builder.build BUILD

task "source:watch", "Watch (build) CoffeeScript to JavaScript.", ->
  builder.watch BUILD

task "docs:build", "Build CoffeeScript to JavaScript.", ->
  cakepop.utils.exec "codo -r README.md -o doc cakepop.coffee"
