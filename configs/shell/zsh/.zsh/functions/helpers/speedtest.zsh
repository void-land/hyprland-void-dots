SPEEDTEST_DOWNLOAD_URL="http://37.32.15.80/assets/12mb.png?_=1711896914991"

wget_speed() {
    check_command wget

    log "Wget Speedtest"

    wget -q --show-progress --progress=bar -O /dev/null $SPEEDTEST_DOWNLOAD_URL
}

curl_speed() {
    check_command curl

    curl $SPEEDTEST_DOWNLOAD_URL >/dev/null
}
