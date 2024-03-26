#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W $WIDTH -H $HEIGHT -r $REFRESH_RATE -e --xwayland-count 2 --adaptive-sync -- steam -gamepadui -steamdeck
}

run_os
