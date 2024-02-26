#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

if [ -z "$WALLPAPER_DAEMON" ]; then
    echo "WALLPAPER_DAEMON is not set in the environment."
    exit 1
fi

case $WALLPAPER_DAEMON in
"swaybg")
    pkill -f swww-daemon
    pkill -f mpvpaper

    exec $HOME/.config/hypr/scripts/swaybg-random.sh
    ;;
"swww")
    pkill -f swaybg
    pkill -f mpvpaper

    if [[ ! $(pidof swww-daemon) ]]; then
        swww init
    fi

    exec $HOME/.config/hypr/scripts/swww-random.sh
    ;;
"mpvpaper")
    pkill -f swaybg
    pkill -f swww-daemon

    exec $HOME/.config/hypr/scripts/mpvpaper-random.sh
    ;;
*)
    echo "Unknown value for WALLPAPER_DAEMON: $WALLPAPER_DAEMON"
    exit 1
    ;;
esac
