# `tmuxify [tmuxify-conf] <command>`

tmuxify runs your site's development scripts in [tmux](https://github.com/tmux/tmux/wiki).

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
restart`.

## tmuxify configuration

To configure tmuxify, you must create a tmuxify.sh file in your project directory,
and then create the scripts used for the tmux panes.

The following is an example tmuxify.sh

    # The site name, used for the tmux session name.
    export SITE_NAME=tmuxify

    # The absolute directory of the site.
    export SITE_PATH=$HOME/src/$SITE_NAME

    # Directory that contains the scripts used to populate the tmux window.
    export SITE_PANES=$HOME/src/$SITE_NAME/panes

    # Path of the tmux executable
    export TMUX=/usr/bin/tmux

    # Path to the tmux server socket.
    #export TMUX_SOCKET=$SITE_PATH/tmux.socket

    # If provided, use this for tmuxify open. localhost at this port will be opened in a browser.
    #export SITE_PORT=8080

If you have multiple tmuxify configurations for a single project, you can specify
that as the first argument, like `tmuxify tmuxify-dev.sh start`.

The panes are simply executable files in the SITE_PANES directory. Each one is used
for a single pane. The pane will have the tmuxify configuration environment variables
in its environment, so SITE_PATH and SITE_PORT can be used. The SITE_PANES scripts
will be run from the SITE_PATH directory.

## Index of tmuxify commands

The following are the main commands used to manage tmuxify.

### tmuxify start
Starts the site if it's not running, attaches, and opens a window

### tmuxify stop
Terminates all panes and closes the tmux window.

### tmuxify restart
Stops the site and starts it again.

### tmuxify attach
Attaches to the existing tmux server, if any. This will open tmux in your
terminal, connected to the site.

### tmuxify open
Opens a browser window to the root site using xdg-open, if SITE_PORT is defined.

## tmuxify utility commands

##### tmuxify cmd <cmd...>
Runs the given command, like `tmux -S $TMUX_SOCKET <cmd...>`. Useful for managing
the site's tmux server directly.

##### tmuxify env
Dumps the site environment used by tmuxify. Used for debugging tmuxify.

##### tmuxify create
Creates a new tmux window for the project. Used in starting tmux.

##### tmuxify is-running
Checks if the site's tmux server is running. Prints `true` and exits zero if
the server is running, otherwise prints `false` and exits nonzero.
