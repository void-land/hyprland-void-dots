#!/usr/bin/env bash

# rofi env :
export launcher_type="2"
export powermenu_type="2"
export rofi_dir="$HOME/.config/rofi"

# waybar env :
export waybar_theme="river"
export waybar_dir="$HOME/.config/waybar/$waybar_theme"
export waybar_launcher="waybar -c $waybar_dir/config.jsonc -s $waybar_dir/style.css"
export inotify_events="-e close_write,move,create"
