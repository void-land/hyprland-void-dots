#!/usr/bin/env bash

source ~/.config/scripts/env.sh

WAYBAR_PID=$(pgrep -x waybar)

if [ -n "$WAYBAR_PID" ]; then
    pkill waybar
elif [ $WAYBAR_DEV_MODE = true ]; then
    GTK_DEBUG=interactive exec $WATCHER -a "$WAYBAR_LAUNCHER" -d "$WAYBAR_DIR" -p "waybar"
else
    exec $WATCHER -a "$WAYBAR_LAUNCHER" -d "$WAYBAR_DIR" -p "waybar"
fi
