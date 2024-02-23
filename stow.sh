#!/bin/bash

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

stow_dotfiles() {
    stow dots
    stow -d dots -S zsh -t ~/
    stow hyprland
    echo "Dotfiles stowed successfully!"
}

unstow_dotfiles() {
    stow -D dots
    stow -D -d dots -t ~/ zsh
    stow -D hyprland
    echo "Dotfiles unstowed successfully!"
}

while getopts ":suh" opt; do
    case $opt in
    s)
        stow_dotfiles
        ;;
    u)
        unstow_dotfiles
        ;;
    *)
        display_help
        ;;
    esac
done
