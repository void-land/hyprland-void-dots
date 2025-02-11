#!/bin/bash

TTF_FONTS_DIR="host/ui/fonts/TTF"
MOUSE_CURSORS_DIR="host/ui/cursors"
ICONS_CURSORS_DIR="host/ui/icons"
ICONS_CURSORS_DIR="host/ui/themes"

THEMES_DESTINATION_DIR="$HOME/.themes"
ICONS_DESTINATION_DIR="$HOME/.icons"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

declare -a ORDERS_LIST=(
    # "CONTAINER_PACKAGES"
    # "DEVEL_PACKAGES"
    "BASE_PACKAGES"
    "AMD_DRIVERS"
    "HYPRLAND_PACKAGES"
    "SYSTEM_APPS"
)

declare -A PACKAGES_LIST=(
    ["SYSTEM_APPS"]="alacritty octoxbps blueman glow"
    ["BASE_PACKAGES"]="usb-modeswitch usb-modeswitch-data xmirror axel curl wget inetutils v4l2loopback bind-utils zellij tmux bat dust aria2 fzf neofetch bat fish-shell brightnessctl bluez cronie git eza dbus seatd elogind polkit NetworkManager polkit-gnome rtkit pipewire wireplumber libspa-bluetooth inotify-tools xorg gnome-keyring polkit-gnome mtpfs ffmpeg libnotify fontconfig-32bit fontconfig"
    ["GAMING_PACKAGES"]="steam MangoHud gamescope gamemode wine winetricks wine-tools wine-common winegui wine-32bit wine-devel wine-devel-32bit lutris"
    ["DEVEL_PACKAGES"]="glib pango-devel gdk-pixbuf-devel libdbusmenu-gtk3-devel glib-devel gtk+3-devel gtk-layer-shell-devel base-devel startup-notification-devel cairo-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel xcb-util-wm-devel"
    ["AMD_DRIVERS"]="opencv Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk mesa-dri mesa-vaapi opencl2-headers mesa-32bit mesa-dri-32bit mesa-vaapi-32bit libglvnd libglapi libglvnd-32bit libglapi-32bit"
    ["HYPRLAND_PACKAGES"]="noto-fonts-emoji socat eww nerd-fonts-symbols-ttf Waybar avizo dunst swaybg mpvpaper grim jq slurp cliphist wl-clipboard swayidle pavucontrol nemo eog pavucontrol evince xorg-server-xwayland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-utils xdg-user-dirs xdg-user-dirs-gtk qt5-x11extras qt5-wayland qt6-wayland qt6ct nwg-look"
    ["CONTAINER_PACKAGES"]="docker docker-compose podman podman-compose catatonit"
)

declare -a SERVICES_LIST=(
    "dbus"
    "crond"
    "seatd"
    "elogind"
    "polkitd"
    "bluetoothd"
    "NetworkManager"
)

declare -a GROUPS_LIST=(
    "wheel"
    "audio"
    "video"
    "network"
    "input"
    "bluetooth"
    "rtkit"
    "_pipewire"
    "_seatd"
)

trap exit_trap SIGINT SIGTERM

exit_trap() {
    echo -e "\n\n${RED}[!]${NC} Installation interrupted. Cleaning up..."

    # pkill -P $$ 2>/dev/null

    exit 1
}

try() {
    local log_file=$(mktemp)

    if ! eval "$@" &>"$log_file"; then
        echo -e "${RED}[!]${NC} Failed: $*"
        cat "$log_file"
        rm -f "$log_file"

        exit 1
    fi

    rm -f "$log_file"
}

log() {
    echo -e "\n${GREEN}[+]${NC} $1"
}

error() {
    echo -e "${RED}[!]${NC} $1"
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

update_xbps() {
    log "Update xbps package manager..."

    if ! ask_prompt "Do you want to update the package manager (xbps)?"; then
        error "Action cancelled..."

        return 0
    fi

    sudo xbps-install -u xbps
}

update_packages() {
    log "Update all packages..."

    if ! ask_prompt "Do you want to perform a full system update?"; then
        error "Action cancelled..."

        return 0
    fi

    sudo xbps-install -Syu
}

setup_packages() {
    local packages_list=""

    for order in "${ORDERS_LIST[@]}"; do
        packages_list+="${PACKAGES_LIST["$order"]} "
    done

    log "Following package groups will be installed:"
    echo -e "$packages_list \n"

    if ! ask_prompt "Do you want to continue with installation?"; then
        error "Action cancelled..."

        return 0
    fi

    log "Installing packages..."

    if ! sudo xbps-install -Sy void-repo-multilib void-repo-nonfree; then
        exit_trap
    fi

    if ! sudo xbps-install -Sy ${packages_list}; then
        exit_trap
    fi
}

setup_hyprland() {
    log "Preparing to install Hyprland and related packages..."

    if ! ask_prompt "Would you like to proceed with installing Hyprland and related packages?"; then
        error "Hyprland installation cancelled."
        return 0
    fi

    log "Adding the Hyprland repository to the package manager..."
    echo 'repository=https://github.com/void-land/hyprland-void-packages/releases/latest/download/' | sudo tee /etc/xbps.d/hyprland-packages.conf

    log "Updating package manager (xbps) and installing Hyprland packages..."
    sudo xbps-install -Sy rofi-wayland swayosd hyprland hyprland-devel aquamarine hyprcursor hypridle hyprland-protocols hyprlang hyprlock hyprpaper hyprutils hyprwayland-scanner xdg-desktop-portal-hyprland
}

setup_services() {
    log "Enable services..."

    if ! ask_prompt "Do you want to enable required services?"; then
        error "Action cancelled..."

        return 0
    fi

    for service in "${SERVICES_LIST[@]}"; do
        local target_service="/etc/sv/$service"

        if [ -d "/var/service/$service" ]; then
            echo "Service $service is already enabled, skipping..."

        elif [ ! -d "$target_service" ]; then
            error "Service $service is not installed, skipping..."
        else
            try "sudo ln -s $target_service /var/service"
            echo "Service $service enabled"
        fi
    done
}

setup_groups() {
    log "Add user to needed groups..."

    if ! ask_prompt "Do you want to add user to groups"; then
        error "Action cancelled..."

        return 0
    fi

    for group in "${GROUPS_LIST[@]}"; do
        sudo usermod -a "$USER" -G "$group"

        echo "$group"
    done
}

setup_fonts() {
    log "Install TTF fonts..."

    if ! ask_prompt "Do you want to install TTF fonts?"; then
        error "Action cancelled..."

        return 0
    fi

    if [ -d "$TTF_FONTS_DIR" ]; then
        sudo cp "$TTF_FONTS_DIR"/* /usr/share/fonts/TTF
        sudo fc-cache -f -v
    else
        error "Font directory $TTF_FONTS_DIR is either empty or does not exist."

        return 0
    fi
}

setup_bibata_cursor() {
    log "Install Bibata-Modern-Ice cursor..."

    if ! ask_prompt "Do you want to install Bibata-Modern-Ice cursor?"; then
        error "Action cancelled..."

        return 1
    fi

    if [ -f "$MOUSE_CURSORS_DIR/Bibata-Modern-Ice.tar.xz" ]; then
        tar -xf "$MOUSE_CURSORS_DIR/Bibata-Modern-Ice.tar.xz" -C /usr/share/icons/

        if [ $? -eq 0 ]; then
            log "Bibata-Modern-Ice cursor installed successfully."
            return 0
        else
            error "Failed to uncompress and install Bibata-Modern-Ice cursor."
            return 1
        fi
    else
        error "Bibata-Modern-Ice.tar.xz file does not exist."
        return 1
    fi
}

while getopts "sfh" opt; do
    case $opt in
    s)
        if [ "$(id -u)" != 0 ]; then
            echo "Please run the script with sudo."

            exit 1
        fi

        clear
        update_xbps
        update_packages
        setup_packages
        setup_hyprland
        setup_services
        setup_groups
        setup_fonts
        setup_bibata_cursor

        log "Setup is done, reboot your system"
        ;;
    f)
        if [ "$(id -u)" != 0 ]; then
            echo "Please run the script with sudo."

            exit 1
        fi

        clear
        setup_fonts

        log "Fonts installed"
        ;;
    h)
        display_help

        exit 1
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
