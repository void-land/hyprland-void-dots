#!/bin/bash

source ./.scripts/utils/main.sh
source ./.scripts/utils/helpers.sh

DOTS_CONFIG_DIR="$(pwd)/linux-configs"
DOTFILES_DIR="$DOTS_CONFIG_DIR/dotfiles"

SHELL_DIR="$DOTS_CONFIG_DIR/shells/zsh"

EDITOR_DIR="$DOTS_CONFIG_DIR/editor/vim"

UTILS_DIR="$DOTS_CONFIG_DIR/utils"

HYPRLAND_ROOT="$(pwd)/hypr-configs"
HYPRLAND_DIR="$HYPRLAND_ROOT/hyprland"
SHORTCUTS_DIR="$HYPRLAND_ROOT/shortcuts"

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
    log "Shell stowed successfully!"

    create_symlinks $EDITOR_DIR ~
    log "Editor stowed successfully!"

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

while getopts "ps" opt; do
    case $opt in
    s)
        stow
        ;;
    u)
        unstow
        ;;
    h)
        display_help
        exit 0
        ;;
    \?)
        display_help
        exit 1
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
