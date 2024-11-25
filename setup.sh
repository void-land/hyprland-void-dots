#!/bin/bash

UPDATE_PKGS=false
CLEAR_CACHE=false
DISABLE_GRUB_MENU=false
TTF_FONTS_DIR="host/ui/fonts/TTF"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

declare -a ORDER=("VOID_REPOS" "CONTAINER_PACKAGES" "BASE_PACKAGES" "DEVEL_PACKAGES" "AMD_DRIVERS" "HYPRLAND_PACKAGES" "SYSTEM_APPS")

declare -A PACKAGES=(
    ["VOID_REPOS"]="void-repo-multilib void-repo-nonfree"
    ["CONTAINER_PACKAGES"]="podman podman-compose catatonit"
    ["BASE_PACKAGES"]="inetutils v4l2loopback bind-utils zellij bat dust aria2 fzf neofetch bat zsh fish-shell brightnessctl bluez cronie git stow eza dbus seatd elogind polkit NetworkManager gnome-keyring polkit-gnome pipewire wireplumber libspa-bluetooth inotify-tools xorg gnome-keyring polkit-gnome mtpfs ffmpeg libnotify"
    ["DEVEL_PACKAGES"]="glib pango-devel gdk-pixbuf-devel libdbusmenu-gtk3-devel glib-devel gtk+3-devel gtk-layer-shell-devel base-devel startup-notification-devel cairo-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel xcb-util-wm-devel"
    ["AMD_DRIVERS"]="opencv Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk mesa-dri mesa-vaapi"
    ["HYPRLAND_PACKAGES"]="noto-fonts-emoji ddcutil socat eww nerd-fonts-symbols-ttf Waybar avizo dunst swaybg mpvpaper grim jq slurp cliphist wl-clipboard swayidle pavucontrol nemo eog pavucontrol evince xorg-server-xwayland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-utils xdg-user-dirs xdg-user-dirs-gtk qt5-x11extras qt5-wayland qt6-wayland"
    ["SYSTEM_APPS"]="alacritty octoxbps blueman wifish wpa_gui glow"
)

declare -a SERVICES=(
    "dbus"
    "seatd"
    "elogind"
    "NetworkManager"
    "polkitd"
    "bluetoothd"
    "crond"
)

trap cleanup SIGINT SIGTERM

cleanup() {
    echo -e "\n\n${RED}[!]${NC} Installation interrupted. Cleaning up..."
    exit 0
}

log() {
    echo -e "${GREEN}[+]${NC} $1"
}

error() {
    echo -e "${RED}[!]${NC} $1"
}

new_line() {
    echo -e "\n"
}

try() {
    local log_file=$(mktemp)

    if ! eval "$@" &>"$log_file"; then
        echo -e "${RED}[!]${NC} Failed: $*"
        cat "$log_file"
    fi

    rm -f "$log_file"
}

params_required() {
    local param_name="$1"
    local param_value="$2"
    local error_message="$3"

    if [ -z "$error_message" ]; then
        error_message="Parameter '$param_name' is required but not provided."
    fi

    if [ -z "$param_value" ]; then
        echo "$error_message" >&2
        exit 1
    fi
}

ask_prompt() {
    local question="$1"

    while true; do
        read -p "$question (Y/N): " choice
        case "$choice" in
        [Yy]) return 0 ;;
        [Nn]) return 1 ;;
        *) echo "Please enter Y or N." ;;
        esac
    done
}

display_help() {
    echo "Usage: [-s | -f] [-h]"
    echo "  -s   Full install"
    echo "  -f   Install host fonts"
}

clear_cache() {
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

update_xbps() {
    log "Update xbps package manager ..."

    if ! ask_prompt "Do you want to update the package manager (xbps)?"; then
        error "Update cancelled..."
        new_line

        return 0
    fi

    sudo xbps-install -u xbps
}

update_packages() {
    log "Update all packages ..."

    if ! ask_prompt "Do you want to perform a full system update?"; then
        error "System update cancelled..."
        new_line

        return 0
    fi

    sudo xbps-install -Syu
}

install_packages() {
    local packages_list=""

    for key in "${ORDER[@]}"; do
        packages_list+="${PACKAGES["$key"]}"
    done

    log "Following package groups will be installed:"
    echo "$packages_list"

    if ! ask_prompt "Do you want to continue with installation?"; then
        echo "Installation cancelled."

        return 0
    fi

    for key in "${ORDER[@]}"; do
        new_line
        log "Installing $key packages..."

        if ! sudo xbps-install -Sy ${PACKAGES["$key"]}; then
            echo "Failed to install $key packages. Exiting..."
        fi
    done
}

assign_groups() {
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

install_ttf_fonts() {
    sudo cp $TTF_FONTS_DIR/* /usr/share/fonts/TTF
    sudo fc-cache -f -v

    log "Fonts installed successfully!"
}

while getopts "sfh" opt; do
    case $opt in
    s)
        if [ "$(id -u)" != 0 ]; then
            echo "Please run the script with sudo."
            exit 1
        fi

        update_xbps
        update_packages
        install_packages

        echo "continue"

        # clear_pkgs_cache
        # add_user_to_groups
        # enable_services
        # enable_pipewire
        # disable_grub_menu

        log "Setup is done, reboot your system"
        ;;
    f)
        check_sudo

        install_ttf_fonts
        ;;
    h)
        display_help
        exit 0
        ;;
    esac
done

# if [[ $# -eq 0 ]]; then
#     display_help
# fi
