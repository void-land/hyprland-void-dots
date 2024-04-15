#!/usr/bin/env bash

# utils shell :
export WATCHER="$HOME/.config/scripts/utils/watcher/main.sh"

# waybar env :
export WAYBAR_DEV_MODE=false
export WAYBAR_THEME="river"
export WAYBAR_DIR="$HOME/.config/waybar/$WAYBAR_THEME"
export WAYBAR_WATCH_DIR="$HOME/.config/waybar"
export WAYBAR_LAUNCHER="waybar -c $WAYBAR_DIR/config.jsonc -s $WAYBAR_DIR/style.css"

# wallpaper configs - swaybg, swww, mpvpaper :
export WALLPAPER_DAEMON="swaybg"
export WALLPAPERS_DIR="$HOME/Wallpapers"
export LIVE_WALLPAPERS_DIR="$HOME/Wallpapers/Live"
export SWWW_FPS=144
export SWWW_DURATION=2

# swayosd configs :
export SWAYOSD_DAEMON="swayosd-server"
export SWAYOSD_DIR="$HOME/.config/swayosd"

# rofi launcher :
export LAUNCHER_TYPE="2"
export CLIPBOARD_TYPE="1"
export WALLPAPER_TYPE="1"
export POWERMENU_TYPE="2"
export ROFI_DIR="$HOME/.config/rofi"
