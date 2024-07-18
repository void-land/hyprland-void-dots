#!/bin/bash

log() {
    local timestamp=$(date +"%T")
    local message="======> $1 : $timestamp"

    echo -e "\n$message\n"
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

params_required() {
    local param_name="$1"
    local param_value="$2"
    local error_message="$3"

    if [ -z "$error_message" ]; then
        error_message="Parameter '$param_name' is required but not provided."
    fi

    if [ -z "$param_value" ]; then
        echo "$error_message" >&2
        exit 1
    fi
}

check_command() {
    if ! command -v $1 &>/dev/null; then
        log "$1 is not installed. Please install $1 to continue."
        exit 1
    fi
}

ask_prompt() {
    local question="$1"
    while true; do
        read -p "$question (Y/N): " choice
        case "$choice" in
        [Yy]) return 0 ;;
        [Nn]) return 1 ;;
        *) echo "Please enter Y or N." ;;
        esac
    done
}
