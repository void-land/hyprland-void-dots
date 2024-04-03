#!/bin/bash

source ./scripts/utils/main.sh
source ./scripts/utils/helpers.sh

CONFIGS_DIR="$(pwd)/configs"
DOTFILES_DIR="$CONFIGS_DIR/dotfiles"
SHELL_DIR="$CONFIGS_DIR/shell/zsh"
UTILS_DIR="$CONFIGS_DIR/utils"
HYPRLAND_DIR="$CONFIGS_DIR/hyprland"
SHORTCUTS_DIR="$CONFIGS_DIR/shortcuts"

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

create_target_dir() {
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.config
}

stow() {
    create_target_dir

    create_symlinks $SHELL_DIR ~
    create_symlinks $DOTFILES_DIR ~/.config
    log "Dotfiles stowed successfully!"

    create_symlinks $HYPRLAND_DIR ~/.config
    log "Hyprland stowed successfully!"

    create_symlinks $SHORTCUTS_DIR ~/.local/share/applications
    log "Shortcuts stowed successfully!"

    create_symlinks $UTILS_DIR ~
    log "Utilities stowed successfully!"
}

unstow() {
    delete_symlinks $SHELL_DIR ~
    delete_symlinks $DOTFILES_DIR ~/.config
    delete_symlinks $HYPRLAND_DIR ~/.config
    delete_symlinks $SHORTCUTS_DIR ~/.local/share/applications
    delete_symlinks $UTILS_DIR ~

    log "All configs ustowed successfully !"
}

while getopts ":suh" opt; do
    case $opt in
    s)
        stow
        ;;
    u)
        unstow
        ;;
    *)
        display_help
        ;;
    esac
done
