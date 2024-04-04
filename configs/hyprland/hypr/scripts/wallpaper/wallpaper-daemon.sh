#!/usr/bin/env bash

source ~/.config/scripts/env.sh

if [ -z "$WALLPAPER_DAEMON" ]; then
    echo "WALLPAPER_DAEMON is not set in the environment."
    exit 1
fi

case $WALLPAPER_DAEMON in
"swaybg")
    pkill -f swww-daemon
    pkill -f mpvpaper

    exec ~/.config/hypr/scripts/wallpaper/swaybg-random.sh
    ;;
"swww")
    pkill -f swaybg
    pkill -f mpvpaper

    if [[ ! $(pidof swww-daemon) ]]; then
        swww init
    fi

    exec ~/.config/hypr/scripts/wallpaper/swww-random.sh
    ;;
"mpvpaper")
    pkill -f swaybg
    pkill -f swww-daemon

    exec ~/.config/hypr/scripts/wallpaper/mpvpaper-random.sh
    ;;
*)
    dunstify "Unknown value for WALLPAPER_DAEMON: $WALLPAPER_DAEMON"
    exit 1
    ;;
esac
