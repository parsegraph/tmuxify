#!/bin/bash

# The site name, used for the tmux session name.
export SITE_NAME=tmuxify

# The absolute directory of the site.
export SITE_PATH=$HOME/src/$SITE_NAME

# Directory that contains the scripts used to populate the tmux window.
export SITE_PANES=$HOME/src/$SITE_NAME/panes

# Path of the tmux executable
#export TMUX=/usr/bin/tmux

# Path to the tmux server socket.
export TMUX_SOCKET=$SITE_PATH/tmux-$SITE_NAME.socket

# If provided, use this for tmuxify open. localhost at this port will be opened in a browser.
#export SITE_PORT=8080
