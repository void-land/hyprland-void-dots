#!/bin/bash

configs_dir="$(pwd)/configs"
shortcuts_dir="$(pwd)/.shortcuts"

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
    ln -sfn $shortcuts_dir/* ~/.local/share/applications

    echo "Shortcuts stowed successfully!"
}

stow_dotfiles() {
    for folder in $configs_dir/dots/*; do
        folder_name=$(basename "$folder")

        if [ ! $folder_name = zsh ]; then
            ln -sfn $configs_dir/dots/$folder_name ~/.config
        fi
    done

    echo "Dotfiles stowed successfully!"
}

unstow_dotfiles() {
    echo "Dotfiles unstowed successfully!"
}

stow_hyprland() {
    ln -sfn $configs_dir/hyprland/* ~/.config

    echo "Hyprland stowed successfully!"
}

unstow_hyprland() {
    for folder in $configs_dir/hyprland/*; do
        folder_name=$(basename "$folder")
        target_folder=~/.config/"$folder_name"

        if [ -e "$target_folder" ]; then
            rm -rf "$target_folder"
            echo "Removed: $target_folder"
        else
            echo "Not found: $target_folder"
        fi
    done
}

while getopts ":suh" opt; do
    case $opt in
    s)
        create_target_dir
        stow_dotfiles
        stow_shortcuts
        stow_hyprland
        ;;
    u)
        unstow_dotfiles
        unstow_hyprland
        ;;
    *)
        display_help
        ;;
    esac
done
