#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 gamescope -W $WIDTH -H $HEIGHT -f -F fsr --sharpness 15 --xwayland-count 2 -- $PCSX2 -fullscreen -bigpicture
}

presetup
run_os
