#!/bin/bash

LINUX_CONFIGS_DIR="$(pwd)/linux-configs"
LINUX_DOTFILES_DIR="$LINUX_CONFIGS_DIR/dotfiles"

NIX_DIR="$LINUX_CONFIGS_DIR/nix"
ZSH_DIR="$LINUX_CONFIGS_DIR/shells/zsh"
FISH_DIR="$LINUX_CONFIGS_DIR/shells/fish"
UTILS_DIR="$LINUX_CONFIGS_DIR/utils"
EDITORS_DIR="$LINUX_CONFIGS_DIR/editors"
ZED_DIR="$LINUX_CONFIGS_DIR/editors/zed"
VIM_DIR="$LINUX_CONFIGS_DIR/editors/vim"
NVIM_DIR="$LINUX_CONFIGS_DIR/editors/nvim"

HYPRLAND_ROOT="$(pwd)/hypr-configs"
HYPRLAND_DIR="$HYPRLAND_ROOT/dotfiles"
SHORTCUTS_DIR="$HYPRLAND_ROOT/shortcuts"

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

log() {
    local timestamp=$(date +"%T")
    local message="======> $1 : $timestamp"

    echo -e "\n$message\n"
}

create_link() {
    local source=$1
    local target=$2

    if [ ! -e "$source" ]; then
        echo "Source does not exist: $source"
        return 1
    fi

    if [ ! -d "$(dirname "$target")" ]; then
        mkdir -p "$(dirname "$target")"
    fi

    if [ -e "$target" ]; then
        rm -rf "$target"
    fi

    ln -sfn "$source" "$target"
    echo "$source ===> $target"
}

create_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ]; then
        echo "Source directory does not exist."
        return 1
    fi

    if [ ! -d $target_dir ]; then
        mkdir -p $target_dir
    fi

    for item in "$source_dir"/* "$source_dir"/.*; do
        if [ -e "$item" ] && [ "$item" != "$source_dir/." ] && [ "$item" != "$source_dir/.." ]; then
            echo "$item ===> $target_dir"

            ln -sfn "$item" "$target_dir/"
        fi
    done
}

delete_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ] || [ ! -d $target_dir ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for config in "$source_dir"/* "$source_dir"/.*; do
        config_name=$(basename $config)
        target_config="$target_dir/$config_name"

        if [ -e "$target_config" ]; then
            rm -rf $target_config
            echo "Removed: $target_config"
        else
            echo "Not found: $target_config"
        fi
    done
}

create_target_dir() {
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.config
}

stow() {
    create_target_dir

    create_link $FISH_DIR ~/.config/fish
    log "Fish dotfiles stowed successfully!"

    create_links $LINUX_DOTFILES_DIR ~/.config
    log "Base dotfiles stowed successfully!"

    create_links $HYPRLAND_DIR ~/.config
    log "Hyprland dotfiles stowed successfully!"

    create_link $ZED_DIR ~/.config/zed
    log "Editors dotfiles stowed successfully!"

    create_links $UTILS_DIR ~
    log "Utilities stowed successfully!"
}

unstow() {
    delete_links $LINUX_DOTFILES_DIR ~/.config
    delete_links $HYPRLAND_DIR ~/.config
    delete_links $SHORTCUTS_DIR ~/.local/share/applications
    delete_links $UTILS_DIR ~

    log "All configs ustowed successfully !"
}

while getopts "ush" opt; do
    case $opt in
    s)
        clear
        stow
        ;;
    u)
        unstow
        ;;
    h)
        display_help
        exit 0
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
