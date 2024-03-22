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

opt_installer() {
    check_command unzip

    local file_path="$1"
    local filename=$(basename "$file_path")
    local opt_dir="/opt"
    local target_file="$opt_dir/$filename"

    if [ ! -e $file_path ]; then
        log "File $file_path not found."
        exit 1
    fi

    if [ ! -e $target_file ]; then
        cp $file_path "$opt_dir/$filename"
    fi

    unzip -o $target_file -d $opt_dir

    if [ $? -eq 0 ]; then
        log "File moved to $opt_dir successfully."
    else
        log "Failed to move file to $opt_dir."
        return 1
    fi
}

download_file() {
    check_command wget

    local url="$1"
    local tmp_dir="/tmp"
    local filename="${2:-$(basename "$url")}"
    local file_path="$tmp_dir/$filename"

    if [ -e "$file_path" ]; then
        if ask_prompt "File $file_path already exists. Do you want to continue ?"; then
            log "Continuing with existing file: $file_path"
            wget -q --show-progress -c -O "$tmp_dir/$filename" "$url"
        else
            log "Deleted existing file: $file_path"
            wget -q --show-progress -O "$tmp_dir/$filename" "$url"
        fi
    else
        wget -q --show-progress -O "$tmp_dir/$filename" "$url"
    fi

    if [ $? -eq 0 ]; then
        log "File downloaded successfully: $tmp_dir/$filename"
    else
        log "Failed to download file from $url"
    fi
}
