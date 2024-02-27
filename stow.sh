#!/bin/bash

configs_dir="$(pwd)/configs"
settings_dir="$(pwd)/.settings"
shortcuts_dir="$(pwd)/.shortcuts"

display_help() {
    echo "Usage: [-s | -u] [-h]"
    echo "  -s   Stow dotfiles"
    echo "  -u   Unstow dotfiles"
    echo "  -h   Display this help message"
}

create_symlinks() {
    source_dir=$1
    target_dir=$2

    if [ ! -d "$source_dir" ] || [ ! -d "$target_dir" ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for item in "$source_dir"/* "$source_dir"/.*; do
        [ -e "$item" ] && [ "$item" != "$source_dir/." ] && [ "$item" != "$source_dir/.." ] && ln -sfn "$item" "$target_dir/"
    done
}

create_target_dir() {
    mkdir -p ~/.local/share/applications
    mkdir -p ~/.config
}

stow_shortcuts() {
    create_symlinks $shortcuts_dir ~/.local/share/applications

    echo "Shortcuts stowed successfully!"
}

unstow_shortcuts() {
    for file in $shortcuts_dir/*; do
        local file_name=$(basename $file)
        local target_file=~/.local/share/applications/$file_name

        if [ -e $target_file ]; then
            rm $target_file
            echo "Removed: $target_file"
        else
            echo "Not found: $target_file"
        fi
    done
}

stow_dotfiles() {
    create_symlinks $configs_dir/dotfiles ~/.config
    create_symlinks $configs_dir/zsh ~/

    ln -sfn $settings_dir/mimeapps.list ~/.config

    echo "Dotfiles stowed successfully!"
}

unstow_dotfiles() {
    for folder in $configs_dir/dotfiles/*; do
        local folder_name=$(basename $folder)
        local target_folder=~/.config/$folder_name

        if [ -e $target_folder ]; then
            rm -rf $target_folder
            echo "Removed: $target_folder"
        else
            echo "Not found: $target_folder"
        fi
    done

    for config in $configs_dir/zsh/.*; do
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

stow_hyprland() {
    create_symlinks $configs_dir/hyprland ~/.config

    echo "Hyprland stowed successfully!"
}

unstow_hyprland() {
    for folder in $configs_dir/hyprland/*; do
        folder_name=$(basename $folder)
        target_folder=~/.config/$folder_name

        if [ -e $target_folder ]; then
            rm -rf $target_folder
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
        unstow_shortcuts
        unstow_hyprland

        echo "All configs stowed successfully !"
        ;;
    *)
        display_help
        ;;
    esac
done
