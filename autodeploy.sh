#!/bin/bash
while true; do
    make &
    sleep 0.2
    inotifywait -e modify -r autodeploy.sh Makefile tmuxify.in
    sleep 0.2
done
