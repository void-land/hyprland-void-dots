#!/bin/bash

source ./scripts/utils/main.sh
source ./scripts/utils/helpers.sh

CONFIGS_DIR="$(pwd)/configs"
DOTFILES_DIR="$CONFIGS_DIR/dotfiles"
SHELL_DIR="$CONFIGS_DIR/shell"
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
    create_symlinks $SHELL_DIR ~/

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

unstow_shell() {
    for config in $SHELL_DIR/.*; do
        if [ -f $config ]; then
            local file_name=$(basename $config)
            local target_file=~/$file_name

            if [ -e $target_file ]; then
                rm $target_file
                echo "Removed: $target_file"
            else
                echo "Not found: $target_file"
            fi

        elif [ -d "$config" ]; then
            local folder_name=$(basename $config)
            local target_folder=~/$folder_name

            if [ -e $target_folder ]; then
                rm -rf $target_folder
                echo "Removed: $target_folder"
            else
                echo "Not found: $target_folder"
            fi
        fi
    done
}

unstow() {
    unstow_shell
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
