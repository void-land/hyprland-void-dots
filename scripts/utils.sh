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
