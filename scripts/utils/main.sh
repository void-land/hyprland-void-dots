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

download_file() {
    check_command wget
    params_required "URL" "$1"

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

extract_file() {
    params_required "File" "$1"
    check_command unzip

    local file_path="$1"
    local tmp_dir="/tmp"
    local target_destination=${2:-$tmp_dir}

    if [ ! -e $file_path ]; then
        log "File $file_path not found."
        exit 1
    fi

    unzip -o $file_path -d $target_destination

    if [ $? -eq 0 ]; then
        log "File extracted successfully: $tmp_dir/$file_path"
    else
        log "Failed to extract file !"
    fi

}

move_to_opt() {
    params_required "Source" "$1"

    local source_path="$1"

    if [ -z "$source_path" ]; then
        log "No source path provided."
        exit 1
    fi

    if [ ! -e "$source_path" ]; then
        log "Source path '$source_path' does not exist."
        return 1
    fi

    if [ ! -d "$source_path" ] && [ ! -f "$source_path" ]; then
        log "Source path '$source_path' is neither a directory nor a file."
        return 1
    fi

    local filename="$(basename "$source_path")"
    local destination="/opt/$filename"

    if [ -e "$destination" ]; then
        if ask_prompt "File or directory '$destination' already exists in /opt. Do you want to cancel ?"; then
            log "Continuing with existing file or directory: $destination"
            exit 1
        else
            log "Deleting existing file or directory: $destination"
            sudo rm -rf "$destination"
        fi
    else
        sudo mv "$source_path" "$destination"
    fi

}
