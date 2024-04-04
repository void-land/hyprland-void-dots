#!/usr/bin/env bash

source ~/.config/scripts/env.sh
WAYBAR_START="$HOME/.config/hypr/scripts/waybar/start.sh"

if pgrep -x waybar >/dev/null; then
    pkill -f waybar
fi

if [ $WAYBAR_DEV_MODE = true ]; then
    GTK_DEBUG=interactive $WAYBAR_START
else
    exec $WAYBAR_START
fi
