#!/usr/bin/env bash

source $HOME/.config/environments/env.sh

if [ -z "$WALLPAPER_DAEMON" ]; then
    echo "WALLPAPER_DAEMON is not set in the environment."
    exit 1
fi

case $WALLPAPER_DAEMON in
"swaybg")
    if [[ $(pidof swww-daemon) ]]; then
        pkill swww-daemon
    fi
    exec $HOME/.config/hypr/scripts/swaybg-random.sh
    ;;
"swww")
    if [[ $(pidof swaybg) ]]; then
        pkill swaybg
    fi
    exec $HOME/.config/hypr/scripts/swww-random.sh
    ;;
*)
    echo "Unknown value for WALLPAPER_DAEMON: $WALLPAPER_DAEMON"
    exit 1
    ;;
esac
