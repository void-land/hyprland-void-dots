connect_to_wifi() {
    echo "Enter the name (SSID) of the Wi-Fi network you want to connect to:"
    read ssid

    echo "Enter the password for the Wi-Fi network:"
    read -s password

    sudo nmcli dev wifi connect "$ssid" password "$password"
}

list_wifi_networks() {
    echo "Available Wi-Fi Networks:"
    nmcli dev wifi list
}

alias wlist="list_wifi_networks"
alias wconnect="connect_to_wifi"
