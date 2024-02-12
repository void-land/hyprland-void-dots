#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

if [[ ! -d "$waybar_dir" ]]; then
    echo "Error: Configuration directory or files missing!"
    exit 1
fi

pkill waybar

while true; do
    logger -i "$0: Starting waybar in the background..."
    exec $waybar_launcher &
    waybar_pid=$!

    logger -i "$0: Started waybar PID=$waybar_pid. Waiting for modifications..."
    inotifywait $inotify_events "$waybar_dir" 2>&1 | logger -i

    if [[ $? -ne 0 ]]; then
        echo "Error: inotifywait failed!"
        exit 1
    fi

    logger -i "$0: inotifywait returned $?. Killing all waybar processes..."
    pkill waybar 2>&1 | logger -i

    if [[ $? -ne 0 ]]; then
        echo "Error: Killing waybar failed!"
        exit 1
    fi

    wait $waybar_pid
    if [[ $? -ne 0 ]]; then
        echo "Warning: Waybar process exited unexpectedly!"
    fi

    logger -i "$0: killall waybar returned $?. Wait a sec..."
done
