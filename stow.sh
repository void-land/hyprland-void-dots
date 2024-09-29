#!/bin/bash

source .scripts/utils/init.sh
source .scripts/utils/_symlinks.sh

LINUX_CONFIGS_DIR="$(pwd)/linux-configs"
LINUX_DOTFILES_DIR="$LINUX_CONFIGS_DIR/dotfiles"

NIX_DIR="$LINUX_CONFIGS_DIR/nix"
ZSH_DIR="$LINUX_CONFIGS_DIR/shells/zsh"
FISH_DIR="$LINUX_CONFIGS_DIR/shells/fish"
UTILS_DIR="$LINUX_CONFIGS_DIR/utils"
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

create_target_dir() {
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.config
}

stow() {
    create_target_dir

    create_links $ZSH_DIR ~
    log "Shell stowed successfully!"

    ln -sfn $FISH_DIR ~/.config/fish
    log "Fish Shell stowed successfully!"

    create_links $NIX_DIR ~/.config
    log "Nix stowed successfully!"

    create_links $VIM_DIR ~
    log "Vim Editor stowed successfully!"

    ln -sfn $NVIM_DIR ~/.config/nvim
    log "Nvim Editor stowed successfully!"

    ln -sfn $ZED_DIR ~/.config/zed
    log "Zed Editor stowed successfully!"

    create_links $LINUX_DOTFILES_DIR ~/.config
    log "Dotfiles stowed successfully!"

    create_links $HYPRLAND_DIR ~/.config
    log "Hyprland stowed successfully!"

    create_links $SHORTCUTS_DIR ~/.local/share/applications
    log "Shortcuts stowed successfully!"

    create_links $UTILS_DIR ~
    log "Utilities stowed successfully!"
}

unstow() {
    delete_links $ZSH_DIR ~
    delete_links $LINUX_DOTFILES_DIR ~/.config
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
