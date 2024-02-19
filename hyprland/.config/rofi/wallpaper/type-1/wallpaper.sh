#!/usr/bin/env bash

wallpapers_dir="$HOME/Wallpapers/"
dir="$HOME/.config/rofi/wallpaper/type-1"
theme='style-8'

rofi_cmd() {
    rofi -dmenu -theme ${dir}/${theme}.rasi
}

show_image_preview() {
    ls --escape "$wallpapers_dir" |
        while read A; do echo -en "$A\x00icon\x1f$wallpapers_dir/$A\n"; done
}

choice=$(
    show_image_preview | rofi_cmd
)

wallpaper="$wallpapers_dir/$choice"

swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration 1 --transition-step 255 --transition-fps 60 "$wallpaper"

exit 1
