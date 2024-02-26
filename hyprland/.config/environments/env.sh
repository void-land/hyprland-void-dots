#!/usr/bin/env bash

# waybar env :
export WAYBAR_DEV_MODE=false
export WAYBAR_THEME="river"
export WAYBAR_DIR="$HOME/.config/waybar/$WAYBAR_THEME"
export WAYBAR_LAUNCHER="waybar -c $WAYBAR_DIR/config.jsonc -s $WAYBAR_DIR/style.css"
export WAYBAR_INOTIFY_EVENTS="-e close_write,move,create"

# wallpaper configs :
export WALLPAPERS_DIR="$HOME/Wallpapers"
export WALLPAPER_DAEMON="swaybg" # swaybg or swww
export SWWW_FPS=144
export SWWW_DURATION=2
