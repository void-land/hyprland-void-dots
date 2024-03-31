#!/usr/bin/env bash

# waybar env :
export WAYBAR_DEV_MODE=false
export WAYBAR_THEME="river"
export WAYBAR_DIR="$HOME/.config/waybar/$WAYBAR_THEME"
export WAYBAR_LAUNCHER="waybar -c $WAYBAR_DIR/config.jsonc -s $WAYBAR_DIR/style.css"
export WAYBAR_INOTIFY_EVENTS="-e close_write,move,create"

# wallpaper configs - swaybg, swww, mpvpaper :
export WALLPAPER_DAEMON="swaybg"
export WALLPAPERS_DIR="$HOME/Wallpapers"
export LIVE_WALLPAPERS_DIR="$HOME/Wallpapers/Live"
export SWWW_FPS=144
export SWWW_DURATION=2

# rofi launcher :
export LAUNCHER_TYPE="2"
export CLIPBOARD_TYPE="1"
export WALLPAPER_TYPE="1"
export POWERMENU_TYPE="2"
export ROFI_DIR="$HOME/.config/rofi"
