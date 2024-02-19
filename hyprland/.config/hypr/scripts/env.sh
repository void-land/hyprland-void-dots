#!/usr/bin/env bash

# waybar env :
export waybar_theme="river"
export waybar_dir="$HOME/.config/waybar/$waybar_theme"
export waybar_launcher="waybar -c $waybar_dir/config.jsonc -s $waybar_dir/style.css"
export inotify_events="-e close_write,move,create"

# swww env :
export wallpapers_dir="$HOME/Wallpapers"
export swww_fps=75
export swww_duration=2
