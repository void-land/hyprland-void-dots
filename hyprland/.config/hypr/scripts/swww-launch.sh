#!/usr/bin/env bash

FPS=75
DIR=$HOME/wallpapers/
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[$RANDOM % ${#PICS[@]}]}

swww query || swww init

swww img ${DIR}/${RANDOMPICS} --transition-fps $FPS --transition-type any --transition-duration 3
