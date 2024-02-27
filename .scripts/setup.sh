#!/bin/bash

# local package install : xbps-install -S --repository <pkg_path> <pkg_fullname>
# exmaple : sudo xbps-install -S --repository hostdir/binpkgs hyprland-0.35.0_1

update_pkgs=false

exec 1> >(tee "../hyprland_setup_log")

log() {
    echo "*********** $1 ***********"
    now=$(date +"%T")
    echo "$now $1" >>../hyprland_setup_log
}

check() {
    if [ "$1" != 0 ]; then
        echo "$2 error : $1" | tee -a ../hyprland_setup_log
        exit 1
    fi
}

# update package manager and system packages :
log "Update xbps/system"
sudo xbps-install -u xbps
if [ $update_pkgs = true ]; then
    sudo xbps-install -Syu
fi
check "$?" "Update xbps/system"
log "xbps/system updated"

# clear cache and older kernels :
sudo xbps-remove -yO
sudo xbps-remove -yo
sudo vkpurge rm all

# install required packages for system :
log "Install base system packages"
sudo xbps-install -Sy \
    git \
    stow \
    dbus \
    seatd \
    elogind \
    polkit \
    NetworkManager \
    gnome-keyring \
    polkit-gnome \
    mesa-dri \
    pipewire \
    wireplumber \
    inotify-tools
check "$?" "Install base system packages"
log "Base packges installed"

log "Install nonfree repo"
sudo xbps-install -Sy \
    void-repo-nonfree

# install hyprland packages :
log "Install Hyprland packages"
sudo xbps-install -Sy \
    xdg-desktop-portal \
    xdg-desktop-portal-wlr \
    swayidle \
    swaylock \
    dunst \
    libnotify \
    Waybar \
    rofi \
    playerctl \
    grim \
    slurp \
    jq \
    cliphist \
    wl-clipboard \
    font-awesome6 \
    blueman \
    bluez \
    brightnessctl \
    libspa-bluetooth \
    mesa-dri \
    nautilus \
    pamixer \
    pavucontrol \
    pulsemixer \
    pipewire \
    terminus-font
check "$?" "Install Hyprland environment"
log "Hyprland environment installed"

log "Symlinking configs"
stow hyprland
check "$?" "Copy settings to home folder"
log "Settings copied"

log "Add user to needed groups"
sudo usermod -a $USER -G _seatd
sudo usermod -a $USER -G bluetooth
check "$?" "Add user to needed groups"
log "User added to needed groups"

log "Disable grub menu"
echo 'GRUB_TIMEOUT=0' | sudo tee -a /etc/default/grub
echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 quiet splash"' | sudo tee -a /etc/default/grub
sudo update-grub
check "$?" "Disable grub menu"
log "Grub menu disabled"

log "Enable services"
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/seatd /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/polkitd /var/service
sudo ln -s /etc/sv/bluetoothd /var/service
check "$?" "Enable services"
log "Services enabled"

log "Setup is done, please log out and log in back again ( type exit )"
