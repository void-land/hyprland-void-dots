#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 STEAM_MULTIPLE_XWAYLANDS=1 gamescope -s 0.4 -e --xwayland-count 2 --adaptive-sync -F fsr -W $WIDTH -H $HEIGHT -r $REFRESH_RATE -- steam -gamepadui
}

presetup
run_os
