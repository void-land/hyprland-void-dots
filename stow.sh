#!/bin/bash

source ./scripts/utils/main.sh
source ./scripts/utils/helpers.sh

CONFIGS_DIR="$(pwd)/configs"
DOTFILES_DIR="$CONFIGS_DIR/dotfiles"
SHELL_DIR="$CONFIGS_DIR/shell/zsh"
SHORTCUTS_DIR="$CONFIGS_DIR/shortcuts"
HYPRLAND_DIR="$CONFIGS_DIR/hyprland"

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

stow_shortcuts() {
    create_symlinks $SHORTCUTS_DIR ~/.local/share/applications

    log "Shortcuts stowed successfully!"
}

stow_dotfiles() {
    create_symlinks $DOTFILES_DIR ~/.config
    create_symlinks $SHELL_DIR ~

    log "Dotfiles stowed successfully!"
}

stow_hyprland() {
    create_symlinks $HYPRLAND_DIR ~/.config

    log "Hyprland stowed successfully!"
}

stow() {
    create_target_dir
    stow_dotfiles
    stow_shortcuts
    stow_hyprland
}

unstow() {
    delete_symlinks $SHELL_DIR ~
    delete_symlinks $DOTFILES_DIR ~/.config
    delete_symlinks $SHORTCUTS_DIR ~/.local/share/applications
    delete_symlinks $HYPRLAND_DIR ~/.config

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
