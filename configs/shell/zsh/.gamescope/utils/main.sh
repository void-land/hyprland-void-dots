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

run_services
