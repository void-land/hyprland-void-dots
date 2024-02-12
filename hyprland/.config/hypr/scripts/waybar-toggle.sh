#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

WAYBAR_PID=$(pgrep -x waybar)

if [ -n "$WAYBAR_PID" ]; then
    pkill waybar
else
    exec $waybar_launcher
fi
