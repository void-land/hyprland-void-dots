#!/usr/bin/env bash

dunst_dir="$HOME/.config/dunst"
inotify_events="-e close_write,move,create"
send_notification=false

case $1 in
d) send_notification=true ;;
h)
    echo "d : dev mode show notif after reset"
    exit 0
    ;;
*) ;;
esac

if [[ ! -d "$dunst_dir" ]]; then
    echo "Error: Configuration directory or files missing!"
    exit 1
fi

pkill dunst
sleep 1

while true; do
    logger -i "$0: Starting dunst in the background..."
    dunst &
    dunst_pid=$!

    if $send_notification; then
        notify-send "Dunst Restarted" "Dunst has been restarted."
    fi

    logger -i "$0: Started dunst PID=$dunst_pid. Waiting for modifications in $dunst_dir..."
    inotifywait $inotify_events "$dunst_dir" 2>&1 | logger -i

    if [[ $? -ne 0 ]]; then
        echo "Error: inotifywait failed!"
        exit 1
    fi

    logger -i "$0: Configuration files in $dunst_dir modified. Killing dunst process..."
    pkill dunst 2>&1 | logger -i

    if [[ $? -ne 0 ]]; then
        echo "Error: Killing dunst failed!"
        exit 1
    fi

    wait $dunst_pid
    if [[ $? -ne 0 ]]; then
        echo "Warning: dunst process exited unexpectedly!"
    fi

    logger -i "$0: killall dunst returned $?. Waiting for the next modifications..."
done
