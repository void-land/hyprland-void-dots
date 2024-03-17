#!/usr/bin/env bash

source $HOME/.config/scripts/env.sh

dir="$HOME/.config/rofi/wallpaper/type-1"
theme='style-8'
thumbnail_dir="$LIVE_WALLPAPERS_DIR/thumbs"

rofi_cmd() {
    rofi -dmenu -theme "${dir}/${theme}.rasi"
}

show_image_preview() {
    for image in "$WALLPAPERS_DIR"/*.{jpg,jpeg,png,gif}; do
        [[ -e $image ]] || continue
        filename=$(basename "$image")
        echo -en "$filename\x00icon\x1f$WALLPAPERS_DIR/$filename\n"
    done
}

set_wallpaper() {
    if [ $WALLPAPER_DAEMON == "mpvpaper" ]; then
        local base_name=$(basename "$1" .png)
        local wallpaper="$LIVE_WALLPAPERS_DIR/$base_name.mp4"
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

generate_video_thumbnails() {
    mkdir -p "$thumbnail_dir"
    total_files=$(find "$LIVE_WALLPAPERS_DIR" -maxdepth 1 -type f \( -iname \*.mp4 \) | wc -l)
    processed_files=0

    shopt -s nullglob
    for video in "$LIVE_WALLPAPERS_DIR"/*.mp4; do
        thumbnail="$LIVE_WALLPAPERS_DIR/thumbs/$(basename "$video" .mp4).png"

        if [ ! -f "$thumbnail" ]; then
            dunstify -u low -t 1000 "Thumbnail Generation"
            sleep 1 && ffmpeg -ss 00:00:02 -i "$video" -frames:v 1 "$thumbnail"
        fi
    done
}

show_video_preview() {
    for image in "$thumbnail_dir"/*.{jpg,jpeg,png,gif}; do
        [[ -e $image ]] || continue
        filename=$(basename "$image")
        echo -en "$filename\x00icon\x1f$thumbnail_dir/$filename\n"
    done
}

if [ $WALLPAPER_DAEMON == "mpvpaper" ]; then
    generate_video_thumbnails
    choice=$(show_video_preview | rofi_cmd)
else
    choice=$(show_image_preview | rofi_cmd)
fi

if [ -n "$choice" ]; then
    set_wallpaper "$choice"
else
    echo "No wallpaper selected."
fi

exit 0
