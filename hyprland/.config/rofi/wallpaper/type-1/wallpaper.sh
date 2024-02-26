#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

dir="$HOME/.config/rofi/wallpaper/type-1"
theme='style-8'

rofi_cmd() {
    rofi -dmenu -theme "${dir}/${theme}.rasi"
}

show_image_preview() {
    find "$WALLPAPERS_DIR" -maxdepth 1 -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) -exec basename {} \; | while read -r A; do
        echo -en "$A\x00icon\x1f$WALLPAPERS_DIR/$A\n"
    done
}

show_video_preview() {
    find "$LIVE_WALLPAPERS_DIR" -maxdepth 1 -type f \( -iname \*.mp4 \) -exec basename {} \; | while read -r A; do
        echo -en "$A\x00icon\x1f$LIVE_WALLPAPERS_DIR/$A\n"
    done
}

set_wallpaper() {
    if [ $WALLPAPER_DAEMON == "mpvpaper" ]; then
        local wallpaper="$LIVE_WALLPAPERS_DIR/$1"
    else
        local wallpaper="$WALLPAPERS_DIR/$1"
    fi

    if [ -f "$wallpaper" ]; then

        case $WALLPAPER_DAEMON in
        "swaybg")
            pkill -f swww-daemon
            pkill -f mpvpaper

            if [[ $(pidof swaybg) ]]; then
                pkill -f swaybg
            fi

            swaybg -i "$wallpaper"
            ;;
        "swww")
            pkill -f swaybg
            pkill -f mpvpaper

            if [[ ! $(pidof swww-daemon) ]]; then
                swww init
            fi

            swww img "$wallpaper" --transition-fps "$SWWW_FPS" --transition-type any --transition-duration "$SWWW_DURATION"
            ;;
        "mpvpaper")
            pkill -f swaybg
            pkill -f swww-daemon

            if [[ $(pidof mpvpaper) ]]; then
                pkill -f mpvpaper
            fi

            mpvpaper -o "loop-file" "*" $wallpaper
            ;;
        *)
            echo "Unknown value for WALLPAPER_DAEMON: $WALLPAPER_DAEMON"
            exit 1
            ;;
        esac
        echo "Wallpaper set to: $wallpaper"
    else
        echo "Error: Wallpaper file not found: $wallpaper"
    fi
}

if [ $WALLPAPER_DAEMON == "mpvpaper" ]; then
    choice=$(show_video_preview | rofi_cmd)
else
    choice=$(show_image_preview | rofi_cmd)
fi

if [ -n "$choice" ]; then
    echo $choice
    set_wallpaper "$choice"
else
    echo "No wallpaper selected."
fi

exit 0
