#!/bin/bash

die() {
    echo $* >&2
    exit 1
}

site_tmux() {
    mkdir -p $SITE_VAR_PATH
    $TMUX -S $SITE_VAR_PATH/tmux.socket "$@"
}

site_tmux_create() {
    mkdir -p $SITE_VAR_PATH
    $TMUX -S $SITE_VAR_PATH/tmux.socket new-session -s $SITE_NAME -d
    for pane in $SITE_PANES/*; do
        if ! test -x $pane; then
            continue 
        fi
        site_tmux split-window -v
        site_tmux select-layout even-vertical
        site_tmux_run "source ./tmuxify.sh"
        site_tmux_run $pane
    done
    site_tmux select-pane -t 0
    site_tmux_run cd $SITE_PATH
    site_tmux_run cat tmuxify.sh
}

site_tmux_has() {
    mkdir -p $SITE_VAR_PATH
    test -e $SITE_VAR_PATH/tmux.socket && site_tmux has -t $SITE_NAME &>/dev/null
}

site_tmux_run() {
    site_tmux send-keys -t $SITE_NAME "$*" C-m
}

test -e ./tmuxify.sh && source ./tmuxify.sh || die "Failed to load tmuxify configuration"
test -n "$TMUX" || die "TMUX must be defined."
test -n "$SITE_NAME" || die "SITE_NAME must be defined."
test -n "$SITE_PATH" || die "SITE_PATH must be defined."
test -d $SITE_PATH || die "SITE_PATH must be defined."
test -n "$SITE_VAR_PATH" || die "SITE_VAR_PATH must be defined."
test -n "$SITE_PANES" || die "SITE_PANES must be provided"
