#!/bin/bash

source .scripts/utils/init.sh
source .scripts/utils/_symlinks.sh

DOTS_CONFIG_DIR="$(pwd)/linux-configs"
DOTFILES_DIR="$DOTS_CONFIG_DIR/dotfiles"

SHELL_DIR="$DOTS_CONFIG_DIR/shells/zsh"
FISH_DIR="$DOTS_CONFIG_DIR/shells/fish"

EDITOR_DIR="$DOTS_CONFIG_DIR/editor/vim"

UTILS_DIR="$DOTS_CONFIG_DIR/utils"

HYPRLAND_ROOT="$(pwd)/hypr-configs"
HYPRLAND_DIR="$HYPRLAND_ROOT/dotfiles"
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

    create_links $SHELL_DIR ~
    log "Shell stowed successfully!"

    ln -sfn $FISH_DIR ~/.config/fish
    log "Fish Shell stowed successfully!"

    create_links $EDITOR_DIR ~
    log "Editor stowed successfully!"

    create_links $DOTFILES_DIR ~/.config
    log "Dotfiles stowed successfully!"

    create_links $HYPRLAND_DIR ~/.config
    log "Hyprland stowed successfully!"

    create_links $SHORTCUTS_DIR ~/.local/share/applications
    log "Shortcuts stowed successfully!"

    create_links $UTILS_DIR ~
    log "Utilities stowed successfully!"
}

unstow() {
    delete_links $SHELL_DIR ~
    delete_links $DOTFILES_DIR ~/.config
    delete_links $HYPRLAND_DIR ~/.config
    delete_links $SHORTCUTS_DIR ~/.local/share/applications
    delete_links $UTILS_DIR ~

    log "All configs ustowed successfully !"
}

while getopts "ush" opt; do
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
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
