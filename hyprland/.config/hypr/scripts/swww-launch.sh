#!/usr/bin/env bash

FPS=75
DIR=$HOME/Wallpapers/
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[$RANDOM % ${#PICS[@]}]}

if [[ $(pidof swaybg) ]]; then
    pkill swaybg
fi

swww query || swww init

swww img ${DIR}/${RANDOMPICS} --transition-fps $FPS --transition-type any --transition-duration 3
