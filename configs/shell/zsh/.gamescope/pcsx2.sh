#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 gamescope --xwayland-count 2 -W $WIDTH -H $HEIGHT -F fsr --sharpness 1 -- $PCSX2 -fullscreen -bigpicture
}

presetup
run_os
