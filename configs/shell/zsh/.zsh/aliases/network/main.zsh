wget_speed() {
    check_command wget

    log "Wget Speedtest"

    wget -q --show-progress --progress=bar -O /dev/null $SPEEDTEST_DOWNLOAD_URL
}

curl_speed() {
    check_command curl

    log "Curl Speedtest"

    curl $SPEEDTEST_DOWNLOAD_URL >/dev/null
}

alias wp="wget_speed"

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

alias wlist="list_wifi_networks"
alias wconnect="connect_to_wifi"
