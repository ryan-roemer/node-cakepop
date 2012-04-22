CakePop!
========
CakePop is a set of CoffeeScript Cake extensions. It provides various helper
wrappers for bash shell commands and other Node.js binary process executions.
Notwithstanding it's CoffeeScript-friendliness, CakePop runs off of real
JavaScript without CoffeeScript dependencies, and is thus appropriate for
use in pure JavaScript code (e.g., with Jakefiles).

See CakePop's own `Cakefile` for example usage.

Documentation is presently in source comments in `cakepop.coffee`. While not
ideal, the source is quite readable. There will be a more friendly version in
the future.

Installation
============
To get the library:

    npm install cakepop

CakePop does **not** install dependencies for tasks that are shell-invoked,
to keep the library small and let the user install the proper version of a
library (like `coffeelint`). So, you will need manual installations for the
following:

* CoffeeScript Build Tasks: `npm install coffee-script`
* Coffeelint: `npm install coffeelint`

Roadmap
=======
* Add documentation.
* Tasks / Helpers:
    * JsHint

License
=======
CakePop is Copyright 2012 Ryan Roemer. Released under the MIT License.
