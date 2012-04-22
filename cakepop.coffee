# CakePop!
#
child_proc  = require 'child_process'

async       = require 'async'
colors      = require 'colors'
extend      = require 'deep-extend'
fileUtils   = require 'file-utils'

# Colors configuration
colors.setTheme
  silly:    'rainbow'
  input:    'grey'
  verbose:  'cyan'
  prompt:   'grey'
  info:     'green'
  data:     'grey'
  help:     'cyan'
  warn:     'yellow'
  debug:    'blue'
  error:    'red'

class Utils

  # Log to console if non-empty string.
  #
  # @param [String] data String to print.
  #
  @print: (data) ->
    data = (data ? "").toString().replace /[\r\n]+$/, ""
    console.log data if data

  # Print error of data message.
  #
  # @param [Object] err   Error.
  # @param [String] data  String to print.
  #
  @printCallback: (err, data) =>
    @print err ? (data ? "Done.").toString()

  # Log failure and exit process.
  #
  # @param [String] msg Failure message.
  #
  @fail: (msg) ->
    process.stderr.write "#{msg}\n".error.bold if msg
    process.exit 1

  # Spawn with log pipes to stdout, stderr.
  #
  # @param [String]         cmd       Command / binary path.
  # @param [Array<String>]  args      Array of arguments to command.
  # @param [Function]       callback  Callback on process end (or null).
  #
  @spawn: (cmd, args = [], callback = null) =>
    @print [cmd, args.join " "].join " "
    ps = child_proc.spawn cmd, args
    ps.stdout.pipe process.stdout
    ps.stderr.pipe process.stderr
    ps.on "exit", callback if callback

  # Exec with log hooks to stdout, stderr.
  #
  # @param [String]   cmd       Command and arguments.
  # @param [Function] callback  Callback on process end (printCallback).
  #
  @exec: (cmd, callback = @printCallback) =>
    @print cmd
    child_proc.exec cmd, (error, stdout, stderr) ->
      process.stderr.write stderr if stderr
      callback error, stdout.toString()

  # Return list of process id's matching egrep pattern.
  #
  # @param [String]   pattern   Egrep pattern.
  # @param [Function] callback  Callback on process end (printCallback).
  #
  @pids: (pattern, callback = @printCallback) =>
    @exec "ps ax | egrep \"#{pattern}\" | egrep -v egrep", (err, matches) ->
      matches = matches?.split("\n") ? []
      callback err, (m.match(/\s*([0-9]+)/)[0] for m in matches when m)

  # Return list of files matching egrep pattern.
  #
  # @param [Array<String>]  dirs      Array of directories (default: ["./"]).
  # @param [String]         pattern   RegExp or string.
  # @param [Function]       callback  Callback on process end (printCallback).
  #
  @find: (dirs = ["./"], pattern, callback = @printCallback) =>
    finder = (dir, cb) =>
      pattern = new RegExp pattern if typeof pattern is 'string'
      paths   = []
      file    = new fileUtils.File dir
      filter  = (name, path) ->
        paths.push path if pattern.test name
        true

      file.list filter, (err) ->
        cb err, paths

    async.map dirs, finder, (err, results) =>
      # Merge arrays
      files = []
      if not err
        files = files.concat r for r in results

      callback err, files

class CoffeeBuild

  # Constructor.
  #
  # Options are in the following (default) format:
  #
  #   coffee:
  #     bin:    "coffee"
  #     suffix: "coffee"
  #
  # @param  [Object]      opts          Options.
  # @option opts [String] coffee.bin    CoffeeScript binary path.
  # @option opts [String] coffee.suffix CoffeeScript file suffix.
  #
  constructor: (opts) ->
    defaults =
      coffee:
        bin:    "coffee"
        suffix: "coffee"

    @coffee = extend defaults.coffee, (opts?.coffee ? {})

  # Raw builder.
  # @private
  #
  _build: (paths, watch, callback) =>
    files     = (p for p in paths when typeof p is 'string')
    dirs      = (p for p in paths when typeof p isnt 'string')
    argsBase  = if watch then ["--watch"] else []

    build = (args, cb) =>
      Utils.spawn "#{@coffee.bin}", argsBase.concat(args), (code) ->
        err = if code is 0 then null else new Error "build failed"
        cb err

    buildDir = (pair, cb) ->
      src = Object.keys(pair)[0]
      dst = pair[src]
      build ["--compile", "--output", dst, src], cb

    cbs =
      buildFiles: (cb) ->
        return cb null if files.length < 1
        build ["--compile"].concat(files), cb

      buildDirs: (cb) ->
        async.forEach dirs, buildDir, cb

    async.parallel cbs, (err) ->
      callback err

  # Build CoffeeScript to JS on an array of files, directory paths.
  #
  # **Note**: The `paths` parameter takes an array of either string source
  # files or object source / destination object pairs.
  #
  # @example paths
  #   paths = [
  #     "foo.coffee",
  #     { "src": "lib" },
  #     "bar.coffee"
  #   ]
  #
  # @param  [Array<Object|String>] paths Array of file and source / dest dirs.
  # @param  [Function] callback Callback on process end (printCallback).
  #
  build: (paths = [], callback = Utils.printCallback) =>
    @_build paths, false, callback

  # Build CoffeeScript to JS with constant watching.
  #
  # **Note**: Takes over a terminal window until stopped (e.g., ctrl-c).
  #
  # **Note**: The `paths` parameter takes an array of either string source
  # files or object source / destination object pairs.
  #
  # @example paths
  #   paths = [
  #     "foo.coffee",
  #     { "src": "lib" },
  #     "bar.coffee"
  #   ]
  #
  # @param  [Array<Object|String>] paths Array of file and source / dest dirs.
  # @param  [Function] callback Callback on process end (printCallback).
  #
  watch: (paths = [], callback = Utils.printCallback) =>
    @_build paths, true, callback

class Style

  # Constructor.
  #
  # Options are in the following (default) format:
  #
  #   coffee:
  #     bin:    "coffeelint"
  #     suffix: "coffee"
  #     config: null
  #
  # @param  [Object]      opts          Options.
  # @option opts [String] coffee.bin    coffeeelint binary path.
  # @option opts [String] coffee.suffix CoffeeScript file suffix.
  # @option opts [String] coffee.config Path to coffeelint config file.
  #
  constructor: (opts) ->
    defaults =
      coffee:
        bin:    "coffeelint"
        suffix: "coffee"
        config: null

    @coffee = extend defaults.coffee, (opts?.coffee ? {})

  # Run coffeelint on an array of files, directory paths.
  #
  # @param  [Array<String>] paths     Array of file / directory paths.
  # @param  [Function]      callback  Callback on process end (printCallback).
  #
  coffeelint: (paths = [], callback = Utils.printCallback) =>
    filesRe = new RegExp "(Cakefile|.*\.#{@coffee.suffix})$"
    config  = if @coffee.config then ["--file", @coffee.config] else []
    files   = (f for f in paths when filesRe.test f)
    dirs    = (f for f in paths when not filesRe.test f)

    cbs =
      searchDirs: (cb) ->
        # No directories to search.
        return cb null, [] if dirs.length < 1

        Utils.find dirs, filesRe, (err, dirFiles) ->
          cb err, dirFiles

      runLint: ["searchDirs", (cb, results) =>
        dirFiles = results?.searchDirs ? []
        args = [config, files, dirFiles].reduce (x, y) -> x.concat y

        Utils.spawn "#{@coffee.bin}", args, (code) ->
          err = if code is 0 then null else new Error "coffeelint failed"
          cb err
      ]

    async.auto cbs, (err) ->
      Utils.fail   "CoffeeScript style checks failed." if err
      Utils.print  "CoffeeScript style checks passed.\n".info
      callback err

module.exports =
  utils:        Utils
  CoffeeBuild:  CoffeeBuild
  Style:        Style
