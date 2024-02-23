#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

dir="$HOME/.config/rofi/wallpaper/type-1"
theme='style-8'

rofi_cmd() {
    rofi -dmenu -theme "${dir}/${theme}.rasi" -p "Chad"
}

show_image_preview() {
    find "$WALLPAPERS_DIR" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) -exec basename {} \; | while read -r A; do
        echo -en "$A\x00icon\x1f$WALLPAPERS_DIR/$A\n"
    done
}

set_wallpaper() {
    local wallpaper="$WALLPAPERS_DIR/$1"
    if [ -f "$wallpaper" ]; then
        swww img "$wallpaper" --transition-fps "$SWWW_FPS" --transition-type any --transition-duration "$SWWW_DURATION"
        echo "Wallpaper set to: $wallpaper"
    else
        echo "Error: Wallpaper file not found: $wallpaper"
    fi
}

choice=$(show_image_preview | rofi_cmd)

if [ -n "$choice" ]; then
    set_wallpaper "$choice"
else
    echo "No wallpaper selected."
fi

exit 0
