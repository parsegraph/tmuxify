#!/bin/bash

die() {
    echo $* >&2
    exit 1
}

site_tmux() {
    if test -n "$TMUX_SOCKET"; then
        $TMUX -S $TMUX_SOCKET "$@"
    else
        $TMUX "$@"
    fi
}

site_tmux_create() {
    site_tmux new-session -s $SITE_NAME -d
    for pane in $SITE_PANES/*; do
        if ! test -f $pane || ! test -x $pane; then
            continue
        fi
        site_tmux split-window
        site_tmux select-layout tiled
        site_tmux_run `tmuxify env`
        site_tmux_run echo "Pane arguments=[$*]"
        site_tmux_run $pane $*
    done
    site_tmux kill-pane -t 0
    site_tmux select-layout tiled
}

site_tmux_has() {
    site_tmux has -t $SITE_NAME &>/dev/null
}

site_tmux_run() {
    site_tmux send-keys -t $SITE_NAME "$*" C-m
}

TMUX=/usr/bin/tmux
if test -e $TMUXIFY_CONF; then
     source $TMUXIFY_CONF || die "Failed to load tmuxify configuration"
elif test "$TMUXIFY_CONF" != `pwd`/tmuxify.sh; then
    die "Custom TMUXIFY_CONF was not found (TMUXIFY_CONF=$TMUXIFY_CONF, `pwd`/tmuxify.sh)"
else
    # Default tmuxify configuration not found; move to parent directory
    pushd . >/dev/null || die "Failed to pushd during tmuxify configuration"
    while test `pwd` != '/'; do
        if test -e tmuxify.sh; then
            export TMUXIFY_CONF=`pwd`/tmuxify.sh
            source $TMUXIFY_CONF || die "Failed to load tmuxify configuration"
            break
        fi
        cd .. || break
    done
    popd >/dev/null || die "Failed to popd after searching for tmuxify configuration"
fi
test -n "$TMUX" || die "TMUX must be defined."
test -e $TMUX || die "tmux executable not found (TMUX=$TMUX)"
test -x $TMUX || die "$TMUX binary is not executable (TMUX=$TMUX)"

if test -z "$SITE_PATH"; then
    SITE_PATH=`pwd`
fi
if test -z "$SITE_NAME"; then
    SITE_NAME=`basename $SITE_PATH`
fi
if test -z "$SITE_URL"; then
    SITE_URL="http://`hostname`"
fi
test -d $SITE_PATH || die "SITE_PATH must be a directory (SITE_PATH=$SITE_PATH)."
if test -z "$SITE_PANES"; then
    pushd . >/dev/null || die "Failed to find site panes"
    while test `pwd` != '/'; do
        # Stop if panes directory is found and we can use this directory as root
        if test -d tmuxify.d; then
            SITE_PATH=`pwd`
            SITE_NAME=`basename $SITE_PATH`
            SITE_PANES=$SITE_PATH/tmuxify.d
            break;
        fi
        cd ..
    done
    popd >/dev/null || die "Failed to find site panes"
fi
test -d $SITE_PANES || die "SITE_PANES must be a directory (SITE_PANES=$SITE_PANES)"

if test -z "`echo $SITE_PANES/*`"; then
    die "No site panes found (SITE_PANES=$SITE_PANES)"
fi
export SITE_PANES
