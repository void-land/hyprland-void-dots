#!/usr/bin/env bash

source ~/.config/scripts/env.sh

exec $WATCHER -a "$WAYBAR_LAUNCHER" -d "$WAYBAR_WATCH_DIR" -p "waybar"
