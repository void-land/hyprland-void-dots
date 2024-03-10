#!/bin/bash

UPDATE_PKGS=false
CLEAR_CACHE=false
DISABLE_GRUB_MENU=false

declare -A PACKAGES=(
    ["BASE_PACKAGES"]="git stow dbus seatd elogind polkit NetworkManager gnome-keyring polkit-gnome mesa-dri pipewire wireplumber inotify-tools void-repo-multilib void-repo-nonfree wpa_supplicant wifish wpa-cute wpa_gui xorg gnome-keyring polkit-gnome mtpfs inotify-tools ffmpeg libnotify git base-devel"
    ["HYPRLAND_PACKAGES"]="Waybar rofi avizo dunst swaybg mpvpaper grim jq slurp cliphist wl-clipboard swayidle"
    ["AMD_DRIVERS"]="opencv Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk mesa-dri"
)

exec 1> >(tee "../hyprland_setup_log")

check_sudo() {
    if [ "$(id -u)" != 0 ]; then
        echo "Please run the script with sudo."
        exit 1
    fi
}

log() {
    local message="*********** $1 ***********"
    local timestamp=$(date +"%T")

    echo -e "\n$message"
    echo "$timestamp $1" >>../hyprland_setup_log
}

check() {
    if [ "$1" != 0 ]; then
        echo "$2 error : $1" | tee -a ../hyprland_setup_log
        exit 1
    fi
}

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

    local services=(
        "/etc/sv/dbus"
        "/etc/sv/seatd"
        "/etc/sv/elogind"
        "/etc/sv/NetworkManager"
        "/etc/sv/polkitd"
        "/etc/sv/bluetoothd"
    )

    for service in "${services[@]}"; do
        if [ -d "$service" ]; then
            echo "Service $service already exists, skipping"
        else
            sudo ln -s "$service" /var/service
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
