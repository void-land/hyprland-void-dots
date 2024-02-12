#!/usr/bin/env bash

MAX_VOLUME=150
DUNST_TIMEOUT=1500

get_current_volume() {
    pactl list sinks | grep '^[[:space:]]Volume:' | head -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}

adjust_volume() {
    local volume=$1
    if [ "$volume" -gt "$MAX_VOLUME" ]; then
        echo "$MAX_VOLUME"
    elif [ "$volume" -lt 0 ]; then
        echo "0"
    else
        echo "$volume"
    fi
}

show_progress_notification() {
    dunstify -a "Volume Control" -u low -t "$DUNST_TIMEOUT" -r 2593 -i audio-volume-medium -h string:x-dunst-stack-tag:volume "Volume: $1%" "$2"
}

calculate_progress() {
    local percentage=$1
    local total=20 # Number of progress bar characters
    local progress=$((percentage * total / 100))
    printf -v progress_bar "%-${progress}s" " "
    printf -v remaining_bar "%-$((total - progress))s" " "
    echo "$progress_bar$remaining_bar"
}

case $1 in
u)
    current_volume=$(get_current_volume)
    new_volume=$((current_volume + 5))
    adjusted_volume=$(adjust_volume "$new_volume")
    pactl set-sink-volume @DEFAULT_SINK@ "$adjusted_volume%"
    show_progress_notification "$adjusted_volume" "$(calculate_progress "$adjusted_volume")"
    ;;
d)
    current_volume=$(get_current_volume)
    new_volume=$((current_volume - 5))
    adjusted_volume=$(adjust_volume "$new_volume")
    pactl set-sink-volume @DEFAULT_SINK@ "$adjusted_volume%"
    show_progress_notification "$adjusted_volume" "$(calculate_progress "$adjusted_volume")"
    ;;
m)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    if pactl list sinks | grep -q "Mute: yes"; then
        show_progress_notification "0" "$(calculate_progress "0")"
    else
        current_volume=$(get_current_volume)
        adjusted_volume=$(adjust_volume "$current_volume")
        pactl set-sink-volume @DEFAULT_SINK@ "$adjusted_volume%"
        show_progress_notification "$adjusted_volume" "$(calculate_progress "$adjusted_volume")"
    fi
    ;;
h)
    echo "u :  volume up"
    echo "d :  volume down"
    echo "m :  mute volume"
    exit 0
    ;;
*) ;;
esac
