#!/usr/bin/env bash

if [[ $(pidof swaybg) ]]; then
    pkill swaybg
fi

swww query || swww init

exec $HOME/.config/hypr/scripts/swww-random.sh
