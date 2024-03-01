#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

WAYBAR_PID=$(pgrep -x waybar)

if [ -n "$WAYBAR_PID" ]; then
    pkill waybar
elif [ $WAYBAR_DEV_MODE = true ]; then
    GTK_DEBUG=interactive exec $WAYBAR_LAUNCHER
else
    exec $WAYBAR_LAUNCHER
fi
