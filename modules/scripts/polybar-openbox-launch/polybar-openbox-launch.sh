#!/usr/bin/env bash

# Kill existing bars
killall -q polybar

# Launch bar on each connected monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -c $HOME/.config/openbox/config.ini --reload example &
done
