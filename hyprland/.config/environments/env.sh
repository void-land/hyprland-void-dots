#!/usr/bin/env bash

# waybar env :
export WAYBAR_THEME="river"
export WAYBAR_DIR="$HOME/.config/waybar/$WAYBAR_THEME"
export WAYBAR_LAUNCHER="waybar -c $WAYBAR_DIR/config.jsonc -s $WAYBAR_DIR/style.css"
export WAYBAR_INOTIFY_EVENTS="-e close_write,move,create"

# swww env :
export WALLPAPERS_DIR="$HOME/Wallpapers"
export SWWW_FPS=144
export SWWW_DURATION=2
