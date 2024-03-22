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

download_file() {
    check_command wget

    local url="$1"
    local tmp_dir="/tmp"
    local filename="${2:-$(basename "$url")}"
    local file_path="$tmp_dir/$filename"

    if [ -e "$file_path" ]; then
        if ask_prompt "File $file_path already exists. Do you want to continue ?"; then
            echo "Continuing with existing file: $file_path"
            wget -c -O "$tmp_dir/$filename" "$url"
        else
            echo "Deleted existing file: $file_path"
            wget -O "$tmp_dir/$filename" "$url"
        fi
    else
        wget -O "$tmp_dir/$filename" "$url"
    fi

    if [ $? -eq 0 ]; then
        echo "File downloaded successfully: $tmp_dir/$filename"
    else
        echo "Failed to download file from $url"
    fi
}
