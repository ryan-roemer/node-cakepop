cakepop = require "./cakepop.coffee"
style   = new cakepop.Style()
builder = new cakepop.CoffeeBuild()

task "dev:coffeelint", "Run CoffeeScript style checks.", ->
  style.coffeelint [
    "Cakefile"
    "cakepop.coffee"
   ]

task "dev:build", "Build CoffeeScript to JavaScript.", ->
  builder.build [
    "cakepop.coffee"
  ]
