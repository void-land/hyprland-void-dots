#!/bin/bash

# Arch Linux Hyprland Setup Script

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
    "BASE_PACKAGES"
    "HYPRLAND_PACKAGES"
    "AUDIO_PACKAGES"
    "GPU_DRIVERS"
    "GAMING_PACKAGES"
    "UTILITIES"
    "FONTS"
)

declare -A PACKAGES_LIST=(
    ["BASE_PACKAGES"]="base-devel git curl xz zstd fzf networkmanager bluez bluez-utils xdg-utils"
    ["HYPRLAND_PACKAGES"]="hyprland hyprpolkitagent xdg-desktop-portal-hyprland hyprpaper hypridle hyprlock hyprsunset orchis-theme swayosd waybar wofi rofi-wayland alacritty grim slurp jq wl-clipboard cliphist"
    ["AUDIO_PACKAGES"]="pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack pavucontrol"
    ["GPU_DRIVERS"]="mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers vulkan-extra-layers vulkan-tools xf86-video-amdgpu amdvlk"
    ["GAMING_PACKAGES"]="gamescope mangohud gamemode lib32-mangohud lib32-gamemode"
    ["UTILITIES"]="nemo evince fish"
    ["FONTS"]="ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji ttf-liberation"
)

declare -a SERVICES_LIST=(
    "NetworkManager"
    "bluetooth"
)

declare -a USER_SERVICES_LIST=(
    "pipewire"
    "wireplumber"
    "pipewire-pulse"
    "hyprpaper"
    "hypridle"
    "hyprpolkitagent"
)

declare -a AUR_PACKAGES=(
    "vazirmatn-fonts"
)

trap exit_trap SIGINT SIGTERM

exit_trap() {
    echo -e "\n\n${RED}[!]${NC} Installation interrupted. Cleaning up..."
    exit 1
}

log() {
    echo -e "\n${GREEN}[+]${NC} $1"
}

error() {
    echo -e "${RED}[!]${NC} $1"
}

ask_prompt() {
    local question="$1"
    while true; do
        read -p "$question (Y/N) [Y]: " choice
        case "$choice" in
        [Yy] | "") return 0 ;; # Accept Y, y, or empty (Enter)
        [Nn]) return 1 ;;
        *) echo "Please enter Y or N (or press Enter for Yes)." ;;
        esac
    done
}

display_help() {
    echo "Usage: $0 [-s | -a | -m | -l | -f] [-h]"
    echo " -s  Full system setup"
    echo " -a  Install AUR packages only"
    echo " -m  Enable multilib repository"
    echo " -u  Setup local fonts"
    echo " -c  Setup mouse cursor"
    echo " -l  Setup locales (Persian)"
    echo " -f  Setup fish shell"
    echo " -h  Show this help"
}

check_root() {
    if [ "$(id -u)" = 0 ]; then
        error "Please run this script as a regular user, not root."
        exit 1
    fi
}

update_system() {
    log "Updating system packages..."
    if ! ask_prompt "Do you want to update the system?"; then
        error "Action cancelled..."
        return 0
    fi
    sudo pacman -Syu --noconfirm
}

setup_multilib() {
    log "Enabling multilib repository..."
    if ! ask_prompt "Do you want to enable multilib repository?"; then
        error "Action cancelled..."
        return 0
    fi

    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo "Multilib repository is already enabled."
        return 0
    fi

    sudo sed -i '/\[multilib\]/,/Include.*mirrorlist/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy
    log "Multilib repository enabled successfully."
}

setup_packages() {
    local packages_list=""
    for order in "${ORDERS_LIST[@]}"; do
        packages_list+="${PACKAGES_LIST["$order"]} "
    done

    log "Following package groups will be installed:"
    echo -e "$packages_list\n"

    if ! ask_prompt "Do you want to continue with installation?"; then
        error "Action cancelled..."
        return 0
    fi

    log "Installing packages..."
    sudo pacman -S --noconfirm $packages_list
}

setup_services() {
    log "Enabling system services..."
    if ! ask_prompt "Do you want to enable required system services?"; then
        error "Action cancelled..."
        return 0
    fi

    for service in "${SERVICES_LIST[@]}"; do
        if systemctl is-enabled "$service" &>/dev/null; then
            echo "Service $service is already enabled, skipping..."
        else
            sudo systemctl enable --now $service
            echo "Service $service enabled"
        fi
    done
}

setup_user_services() {
    log "Enabling user services..."
    if ! ask_prompt "Do you want to enable user services?"; then
        error "Action cancelled..."
        return 0
    fi

    for service in "${USER_SERVICES_LIST[@]}"; do
        if systemctl --user is-enabled "$service" &>/dev/null; then
            echo "User service $service is already enabled, skipping..."
        else
            systemctl --user enable --now $service
            echo "User service $service enabled"
        fi
    done
}

setup_aur_packages() {
    log "Installing AUR packages..."
    if ! ask_prompt "Do you want to install AUR packages ?"; then
        error "Action cancelled..."
        return 0
    fi

    if ! command -v yay &>/dev/null; then
        log "Installing yay AUR helper..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~
    fi

    for package in "${AUR_PACKAGES[@]}"; do
        log "Installing $package from AUR..."
        yay -S --noconfirm $package
    done
}

setup_locales() {
    log "Setting up Persian locale..."
    if ! ask_prompt "Do you want to enable Persian locale (fa_IR UTF-8)?"; then
        error "Action cancelled..."
        return 0
    fi

    if grep -q "^fa_IR UTF-8" /etc/locale.gen; then
        echo "Persian locale is already uncommented."
    else
        sudo sed -i 's/#fa_IR UTF-8/fa_IR UTF-8/' /etc/locale.gen
    fi

    sudo locale-gen
    log "Persian locale enabled successfully."
}

setup_fish_shell() {
    log "Setting up Fish shell..."
    if ! ask_prompt "Do you want to set Fish as your default shell?"; then
        error "Action cancelled..."
        return 0
    fi

    if ! grep -q "/bin/fish" /etc/shells; then
        echo /bin/fish | sudo tee -a /etc/shells
    fi

    chsh -s /bin/fish
    log "Fish shell set as default. Changes will take effect after logout/login."
}

setup_fonts() {
    log "Install TTF fonts..."

    if ! ask_prompt "Do you want to install TTF fonts?"; then
        error "Action cancelled..."

        return 0
    fi

    sudo mkdir -p /usr/share/fonts/TTF

    if [ -d "$TTF_FONTS_DIR" ]; then
        sudo cp -v "$TTF_FONTS_DIR"/* /usr/share/fonts/TTF
        sudo fc-cache -f -v
    else
        error "Font directory $TTF_FONTS_DIR is either empty or does not exist."

        return 0
    fi
}

setup_mouse_cursor() {
    log "Install Bibata-Modern-Ice cursor..."

    if ! ask_prompt "Do you want to install Bibata-Modern-Ice cursor?"; then
        error "Action cancelled..."

        return 1
    fi

    sudo mkdir -p /usr/share/icons/

    if [ -f "$MOUSE_CURSORS_DIR/Bibata-Modern-Ice.tar.xz" ]; then
        tar xfv "$MOUSE_CURSORS_DIR/Bibata-Modern-Ice.tar.xz" -C /usr/share/icons/

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

full_setup() {
    check_root
    clear
    log "Starting full Arch Linux Hyprland setup..."

    update_system
    setup_multilib
    setup_packages
    setup_services
    setup_user_services
    setup_aur_packages
    setup_locales
    setup_mouse_cursor
    setup_fonts
    setup_fish_shell

    log "Setup completed! Please reboot your system to ensure all changes take effect."
    echo -e "${BLUE}Note:${NC} After reboot, Hyprland should be available in your display manager."
}

while getopts "samlhfuc" opt; do
    case $opt in
    s)
        full_setup
        ;;
    a)
        check_root
        setup_aur_packages
        ;;
    m)
        check_root
        setup_multilib
        ;;
    l)
        check_root
        setup_locales
        ;;
    f)
        check_root
        setup_fish_shell
        ;;
    u)
        check_root
        setup_fonts
        ;;
    c)
        check_root
        setup_mouse_cursor
        ;;
    h)
        display_help
        exit 0
        ;;
    *)
        display_help
        exit 1
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    display_help
fi
