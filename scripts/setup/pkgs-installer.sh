#!/bin/bash

source ../utils/main.sh

UPDATE_PKGS=false
CLEAR_CACHE=false
DISABLE_GRUB_MENU=false

declare -A PACKAGES=(
    ["VOID_REPOS"]="void-repo-multilib void-repo-nonfree"
    ["BASE_PACKAGES"]="bind-utils zellij bat dust aria2 fzf neofetch bat zsh fish-shell brightnessctl bluez cronie git stow eza dbus seatd elogind polkit NetworkManager gnome-keyring polkit-gnome pipewire wireplumber inotify-tools xorg gnome-keyring polkit-gnome mtpfs inotify-tools ffmpeg libnotify"
    ["DEVEL_PACKAGES"]="base-devel startup-notification-devel cairo-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel xcb-util-wm-devel"
    ["AMD_DRIVERS"]="opencv Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk mesa-dri mesa-vaapi"
    ["HYPRLAND_PACKAGES"]="Waybar avizo dunst swaybg mpvpaper grim jq slurp cliphist wl-clipboard swayidle pavucontrol nemo eog pavucontrol evince xorg-server-xwayland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-utils qt5-x11extras qt5-wayland qt6-wayland"
    ["SYSTEM_APPS"]="alacritty octoxbps blueman wifish wpa_gui"
)

declare SERVICES=(
    "dbus"
    "seatd"
    "elogind"
    "NetworkManager"
    "polkitd"
    "bluetoothd"
    "crond"
)

update_system() {
    log "Update xbps package manager"
    sudo xbps-install -u xbps

    if [ $UPDATE_PKGS = true ]; then
        sudo xbps-install -Syu
        check "$?" "Update xbps/system"
        log "xbps/system updated"
    else
        log "Skipping full system update"
    fi
}

clear_pkgs_cache() {
    if [ $CLEAR_CACHE = true ]; then
        log "Clear package manager cache"
        sudo xbps-remove -yO
        sudo xbps-remove -yo
        sudo vkpurge rm all
        log "Package manager cache cleared"
    else
        log "Skipping package manager cache clearance"
    fi
}

pkgs_installer() {
    local log_message=$1
    shift
    local -a package_list=("$@")

    log "$log_message"
    sudo xbps-install -Sy "${package_list[@]}"
    check "$?" "$log_message"
}

install_pkgs() {
    for package_set in $(echo "${!PACKAGES[@]}" | tr ' ' '\n' | sort); do
        pkgs_installer "Install $package_set" ${PACKAGES["$package_set"]}
        log "$package_set installed"
    done
}

add_user_to_groups() {
    log "Add user to needed groups"
    sudo usermod -a $USER -G _seatd
    sudo usermod -a $USER -G bluetooth
    check "$?" "Add user to needed groups"
    log "User added to needed groups"
}

enable_services() {
    log "Enable services"

    for service in "${SERVICES[@]}"; do
        local target_service="/etc/sv/$service"

        if [ -d "/var/service/$service" ]; then
            echo "Service "$target_service" already exists, skipping"
        elif [ ! -d "$target_service" ]; then
            echo "Service "$target_service" is not installed"
        else
            sudo ln -s "$target_service" /var/service
            check "$?" "Enable service: $service"
            echo "Service $service enabled"
        fi
    done

    log "Services enabled"
}

disable_grub_menu() {
    if [ $DISABLE_GRUB_MENU = true ]; then
        log "Disable grub menu"
        echo 'GRUB_TIMEOUT=0' | sudo tee -a /etc/default/grub
        echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub
        echo 'GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 quiet splash"' | sudo tee -a /etc/default/grub
        sudo update-grub
        check "$?" "Disable grub menu"
        log "Grub menu disabled"
    else
        log "Skipping grub menu disable"
    fi
}

check_sudo

update_system
clear_pkgs_cache
install_pkgs
add_user_to_groups
enable_services
disable_grub_menu

log "Setup is done, please log out and log in"
