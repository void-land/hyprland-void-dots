#!/usr/bin/env bash

run_services() {
    exec dbus-update-activation-environment --all
    exec ~/.config/scripts/pipewire.sh
}

run_steamos() {
    local width=1600
    local height=900
    local refresh_rate=75

    STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W "$width" -H "$height" -r "$refresh_rate" -e --xwayland-count 2 --adaptive-sync -- steam -gamepadui -steamdeck
}

run_services

run_steamos
