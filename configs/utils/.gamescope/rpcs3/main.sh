#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 gamescope -W $WIDTH -H $HEIGHT -F fsr --sharpness 1 -- $RPCS3
}

presetup
run_os
