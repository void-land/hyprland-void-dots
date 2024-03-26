#!/usr/bin/env bash

check_and_start() {
    if ! pgrep -x "$1" >/dev/null; then
        echo "Starting $1..."
        sleep 1 && $2 &
    else
        echo "$1 is already running."
    fi
}

run_services() {
    dbus-update-activation-environment --all && sleep 1
    check_and_start "pipewire" "/usr/bin/pipewire"
    check_and_start "pipewire-pulse" "/usr/bin/pipewire-pulse"
    check_and_start "wireplumber" "/usr/bin/wireplumber"
}

run_steamos() {
    local WIDTH=1920
    local HEIGHT=1080
    local REFRESH_RATE=75

    MAGOHUD=1 STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W $WIDTH -H $HEIGHT -r $REFRESH_RATE -e --xwayland-count 2 --adaptive-sync -- steam -gamepadui -steamdeck
}

run_services

run_steamos
