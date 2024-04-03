alias void-pkgs="cd $VOID_PACKAGES_PATH"
alias vshutdown="sudo shutdown -h now"
alias vreboot="sudo reboot"
alias vrepos="xbps-query -L"
alias vpkgf="xbps-query -f"
alias vpkg="sudo xbps-install -S"
alias vup="sudo xbps-install -Su"
alias vrm="sudo xbps-remove -R"
alias vcpurge="sudo xbps-remove -O"
alias vsearch="xbps-query -Rs"
alias vinfo="xbps-query -S"
alias vlocate="xbps-query -f"
alias vlist="xbps-query -l"
alias vrepos="xbps-query -L"
alias vhold="sudo xbps-pkgdb -m hold"
alias vunhold="sudo xbps-pkgdb -m unhold"
alias vmirror="sudo xmirror"
alias killall="pkill -f"

alias svservices="ls /etc/sv/"
alias svlist="ls -la /var/service/"
alias svreset="sudo sv restart"
alias svstatus="sudo sv status"
alias svon="sudo sv up"
alias svoff="sudo sv down"

svenable() {
    if [ -z "$1" ]; then
        echo "Error: Please provide the path of the service to add"
        return 1
    fi
    sudo ln -s $1 /var/service
}

svdisable() {
    if [ -z "$1" ]; then
        echo "Error: Please provide the name of the service to remove"
        return 1
    fi
    sudo rm -rf "/var/service/$1"
}

alias rmhyprland="vrm hyprland hyprland-protocols hyprlang xdg-desktop-portal-hyprland"

installhyprland() {
    if [ -z "$1" ]; then
        echo "Error: Please provide the path of packages"
        return 1
    fi
    sudo xbps-install -R $1 hyprland hyprland-protocols hyprlang xdg-desktop-portal-hyprland
}
