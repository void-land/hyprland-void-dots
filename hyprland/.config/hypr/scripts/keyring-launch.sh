#!/usr/bin/env bash

if [ $(grep -i -w "ID=" /etc/os-release | grep -oP '(?<=")[^"]*') = void ]; then
    exec gnome-keyring-daemon -sd
    exec /usr/libexec/polkit-gnome-authentication-agent-1
else
    exec gnome-keyring-daemon -sd
    exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
fi
