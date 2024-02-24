#!/bin/bash

dots_dir="dots"
hyprland_dir="hyprland"
shortcuts_target_dir="$HOME/.local/share/applications"

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

stow_shortcuts() {
    mkdir -p $shortcuts_target_dir
    stow -d $dots_dir -S shortcuts -t $shortcuts_target_dir

    echo "Shortcuts stowed successfully!"
}

stow_dotfiles() {
    stow $dots_dir
    stow -d $dots_dir -S zsh -t ~/
    stow $hyprland_dir

    echo "Dotfiles stowed successfully!"
}

unstow_dotfiles() {
    stow -D $dots_dir
    stow -D -d $dots_dir -t ~/ zsh
    stow -D -d $dots_dir -t $shortcuts_target_dir shortcuts
    # stow -D $hyprland_dir

    echo "Dotfiles unstowed successfully!"
}

while getopts ":suh" opt; do
    case $opt in
    s)
        stow_dotfiles
        stow_shortcuts
        ;;
    u)
        unstow_dotfiles
        ;;
    *)
        display_help
        ;;
    esac
done
