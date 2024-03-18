#!/usr/bin/env bash

run_services() {
    exec $HOME/.config/scripts/pipewire.sh
}

run_steamos() {
    local WIDTH=1600
    local HEIGHT=900
    local REFRESH_RATE=75

    STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W $WIDTH -H $HEIGHT -r $REFRESH_RATE -e --xwayland-count 2 --adaptive-sync -- steam -gamepadui -steamdeck
}

run_services

run_steamos
