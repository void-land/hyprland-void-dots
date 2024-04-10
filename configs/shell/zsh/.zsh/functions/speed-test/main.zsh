wget_speed() {
    check_command wget

    log "WGET Speedtest"
    log "URL $SPEEDTEST_DOWNLOAD_URL"

    wget -q --show-progress --progress=bar -O /dev/null $SPEEDTEST_DOWNLOAD_URL
}

curl_speed() {
    check_command curl

    log "Curl Speedtest"

    curl $SPEEDTEST_DOWNLOAD_URL >/dev/null
}

alias wp="wget_speed"
