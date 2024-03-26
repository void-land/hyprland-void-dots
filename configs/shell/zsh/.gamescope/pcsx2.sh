#!/usr/bin/env bash

source ~/.gamescope/utils/main.sh
source ~/.gamescope/configs.sh

run_os() {
    MANGOHUD=1 gamescope -W 1920 -H 1080 -f -F fsr -- $PCSX2 -fullscreen -bigpicture
}

run_os
