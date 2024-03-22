#!/bin/bash

log() {
    local timestamp=$(date +"%T")
    local message="======> $1 : $timestamp"

    echo -e "\n$message"
}

check_sudo() {
    if [ "$(id -u)" != 0 ]; then
        echo "Please run the script with sudo."
        exit 1
    fi
}

check() {
    if [ "$1" != 0 ]; then
        echo "$2 error : $1" | tee -a ../hyprland_setup_log
        exit 1
    fi
}
