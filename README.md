# `tmuxify [tmuxify-conf] <command>`

tmuxify runs your site's development scripts in [tmux](https://github.com/tmux/tmux/wiki) panes.

## How to install tmuxify

Clone this tmuxify repository and run `make` to create `tmuxify`. Copy that
executable to a directory in your path. If you move the tmuxify repository, you
must reinstall tmuxify.

## How to run tmuxify

1. Make scripts in a panes/ directory to build and run your project.
2. Create a tmuxify.sh using the example below.
3. `tmuxify start` to start the tmux server.

tmux should open in your terminal, and if you have defined `SITE_PORT`,
a browser window should also open, pointing to `https://localhost:$SITE_PORT`

To exit tmux without stopping your scripts, type `C-b` followed by `d`.

To shut down your server, run `tmuxify stop`. To restart it, run `tmuxify
restart`. To check if it is running, use `tmuxify is-running`.

`tmuxify start` and `tmuxify restart` will pass any extra arguments to your
site's pane scripts. You can use this to set run-time configuration. A common
use-case is passing a different SITE_PORT value to your scripts. The scripts
can check for this port, and configure their service appropriately at run-time.

`tmuxify start` will open a browser window using the site's root port, which defaults
to the SITE_PORT environment variable, but will be overridden by the first passed
argument, if any.

## tmuxify configuration

To configure tmuxify, you can create a tmuxify.sh file in your project directory,
and then create the scripts used for the tmux panes. The tmuxify.sh file is
optional, but at least one script must be in panes for tmuxify to work.

The following is an example tmuxify.sh

    # The site name, used for the tmux session name.
    # default is the basename of the running directory
    export SITE_NAME=tmuxify

    # The absolute directory of the site.
    # default is the current directory
    export SITE_PATH=$HOME/src/$SITE_NAME

    # Directory that contains the scripts used to populate the tmux window.
    # default is SITE_PATH/panes
    export SITE_PANES=$HOME/src/$SITE_NAME/panes

    # Path to a custom tmux executable
    #export TMUX=/usr/bin/tmux

    # Path to the tmux server socket.
    #export TMUX_SOCKET=$SITE_PATH/tmux.socket

    # Use this for tmuxify open. localhost at this port will be opened in a browser.
    #export SITE_PORT=8080

    # Use this for tmuxify open. This URL will be opened in a browser, with the port appended.
    #export SITE_URL="https://`hostname`"

If you have multiple tmuxify configurations for a single project, you can specify
that as the first argument, like `tmuxify tmuxify-dev.sh start`.

The pane scripts are simply executable files in the SITE_PANES directory. Each
one is used for a single pane. The SITE_PANES scripts will be run from the
SITE_PATH directory. The pane will have the tmuxify configuration environment
variables in its environment, so SITE_PATH and SITE_PORT can be used.

## Main tmuxify commands

The following are the main commands used to manage tmuxify. An alias can be used for
the command's canonical name:

    tmuxify rs 8080 # Restart the site using port 8080

### `tmuxify start [site-port] [args...]`
Starts the site if it's not running, attaches, and opens a window.

The site port and other arguments are passed to each script. The script's environment
will be populated with site environment variables. See "tmuxify configuration" for a list
of these variables.

Aliases: run, go, up

### `tmuxify stop`
Terminates all panes and closes the tmux window.

Aliases: down, kill, rm

### `tmuxify restart [site-port] [args...]`
Stops the site and starts it again.

The site port and other arguments are passed to each script. The script's environment
will be populated with site environment variables. See `tmuxify env` for the list.

Alias: rs

### `tmuxify attach`
Attaches to the existing tmux server, if any. This will open tmux in your
terminal, connected to the site.

Alias: a, at, att

### `tmuxify open [site-port]`
Opens a browser window to the root site using xdg-open, if SITE_PORT is defined.
The command-line SITE_PORT overrides the one from the tmuxify configuration.

Alias: o

### `tmuxify is-running`
Checks if the site's tmux server is running. Prints `true` and exits zero if
the server is running, otherwise prints `false` and exits nonzero.

Alias: st, status

## tmuxify utility commands

#### `tmuxify cmd <cmd...>`
Runs the given command, like `tmux -S $TMUX_SOCKET <cmd...>`. Useful for managing
the site's tmux server directly.

Alias: tmux

#### `tmuxify env`
Dumps the site environment used by tmuxify. Used for debugging tmuxify.

#### `tmuxify create [args...]`
Creates a new tmux window for the project. Used in starting tmux.

Arguments are passed to each script.

#### `tmuxify help`
Show command-line help.

This is shown if an unrecognized command is given.

Alias: info
