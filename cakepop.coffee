####
# CakePop!
####
child_proc  = require 'child_process'

colors      = require 'colors'

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

class CakePop

  # Log to console if non-empty string.
  #
  # @param [String] data String to print.
  #
  @print: (data) ->
    data = (data ? "").toString().replace /[\r\n]+$/, ""
    console.log data if data

  # Print "done" or error.
  #
  # @param [Object] err Error.
  #
  @printOnError: (err) =>
    @print err ? "Done."

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
  # @param [String]         cmd       Command and arguments.
  # @param [Function]       callback  Callback on process end (default: print).
  #
  @exec: (cmd, callback = @print) =>
    @print cmd
    child_proc.exec cmd, (error, stdout, stderr) ->
      process.stderr.write stderr if stderr
      callback stdout.toString()

  # Return list of process id's matching egrep pattern.
  #
  # @param [String]   pattern   Egrep pattern.
  # @param [Function] callback  Callback on process end (default: print).
  #
  @pids: (pattern, callback = @print) =>
    @exec "ps ax | egrep \"#{pattern}\" | egrep -v egrep", (matches) ->
      matches = matches?.split("\n") ? []
      callback (m.match(/\s*([0-9]+)/)[0] for m in matches when m)

  # Return list of files matching egrep pattern.
  #
  # @param [String]   start     Starting directory (default: "./").
  # @param [String]   pattern   Egrep pattern.
  # @param [Function] callback  Callback on process end (default: print).
  #
  @find: (start = "./", pattern, callback = @print) =>
    start = "{#{start.join(',') }}" if Array.isArray start
    @exec "find #{start} -name \"#{pattern}\"", (files) ->
      files = files?.split("\n") ? []
      callback (f for f in files when f)

  # Run coffeelint on an array of files, directory paths.
  #
  # @param  [Array<String>]   paths     Array of file / directory paths.
  # @param  [Object]          opts      Options.
  # @option options [String]  suffix    CoffeeScript file suffix ("coffee").
  # @option options [String]  config    Path to coffeelint config file.
  # @param  [Function]        callback  Callback on process end (or null).
  #
  @coffeelint: (paths = [], opts = {}, callback = @printOnError) =>
    suffix  = opts.suffix ? "coffee"
    filesRe = new RegExp ".*\.#{suffix}$"
    isCs    = (name) -> name is "Cakefile" or filesRe.test name

    config  = if opts.config then ["--file", opts.config] else []
    files   = (f for f in paths when isCs f)
    dirs    = (f for f in paths when not isCs f)

    @find dirs, "*.#{suffix}", (dirFiles) =>
      args = files.concat(dirFiles).concat(config)
      @spawn "coffeelint", args, (code) =>
        @fail   "CoffeeScript style checks failed." unless code is 0
        @print  "CoffeeScript style checks passed.\n".info
        callback()

module.exports = CakePop
