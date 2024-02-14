#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

if [[ $(pidof swaybg) ]]; then
    pkill swaybg
fi

swww query || swww init

swww img $wallpapers_dir/macos.jpg --transition-fps $swww_fps --transition-type any --transition-duration $swww_duration
