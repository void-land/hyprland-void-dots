#!/bin/bash

stow_dotfiles() {
    stow dots
    stow -d dots -S zsh -t ~/
    stow hyprland

    echo "Dotfiles stowed successfully!"
}

stow_dotfiles
