#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

dir="$HOME/.config/rofi/wallpaper/type-1"
theme='style-8'

rofi_cmd() {
    rofi -dmenu -theme ${dir}/${theme}.rasi -p "Chad"
}

show_image_preview() {
    ls --escape "$WALLPAPERS_DIR" |
        while read A; do echo -en "$A\x00icon\x1f$WALLPAPERS_DIR/$A\n"; done
}

choice=$(
    show_image_preview | rofi_cmd
)

wallpaper="$WALLPAPERS_DIR/$choice"

swww img "$wallpaper" --transition-fps $SWWW_FPS --transition-type any --transition-duration $SWWW_DURATION

exit 1
