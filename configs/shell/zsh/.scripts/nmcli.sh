#!/bin/bash

source ~/.scripts/utils/main.sh

list_wifi_networks() {
    echo "Available Wi-Fi Networks:"
    nmcli dev wifi list
}

connect_to_wifi() {
    echo "Enter the name (SSID) of the Wi-Fi network you want to connect to:"
    read ssid

    echo "Enter the password for the Wi-Fi network:"
    read -s password

    sudo nmcli dev wifi connect "$ssid" password "$password"
}

list_wifi_networks

if ask_prompt "Do you want to connect to a Wi-Fi network ?"; then
    connect_to_wifi
else
    echo "No network connection requested. Exiting."
fi
