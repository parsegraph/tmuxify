#!/bin/bash

die() {
    echo $* >&2
    exit 1
}

site_tmux() {
    $TMUX -S $TMUX_SOCKET "$@"
}

site_tmux_create() {
    $TMUX -S $TMUX_SOCKET new-session -s $SITE_NAME -d
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
    test -e $TMUX_SOCKET && site_tmux has -t $SITE_NAME &>/dev/null
}

site_tmux_run() {
    site_tmux send-keys -t $SITE_NAME "$*" C-m
}

test -e ./tmuxify.sh && source ./tmuxify.sh || die "Failed to load tmuxify configuration"
test -n "$TMUX" || die "TMUX must be defined."
test -e $TMUX || die "tmux executable not found (TMUX=$TMUX)"
test -x $TMUX || die "$TMUX binary is not executable (TMUX=$TMUX)"
test -n "$TMUX_SOCKET" || die "TMUX_SOCKET must be defined."
test -n "$SITE_NAME" || die "SITE_NAME must be defined."
test -n "$SITE_PATH" || die "SITE_PATH must be defined."
test -d $SITE_PATH || die "SITE_PATH must be defined."
test -n "$SITE_PANES" || die "SITE_PANES must be provided"
