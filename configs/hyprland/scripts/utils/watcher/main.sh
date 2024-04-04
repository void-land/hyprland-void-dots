#!/usr/bin/env bash

usage() {
    echo "Usage: $0 -a <application_name> -d <directory_to_watch> -p <process_name>"
    exit 1
}

while getopts ":a:d:p:" opt; do
    case $opt in
    p) process_name="$OPTARG" ;;
    a) app_name="$OPTARG" ;;
    d) watch_dir="$OPTARG" ;;
    *) usage ;;
    esac
done

if [[ -z $app_name || -z $watch_dir || -z $process_name ]]; then
    usage
fi

if [[ ! -d $watch_dir ]]; then
    echo "Error: Directory $watch_dir does not exist!"
    exit 1
fi

start_application() {
    echo "Starting $process_name..."
    pkill $process_name
    exec $app_name
}

restart_application() {
    if pgrep -x "$process_name" >/dev/null; then
        echo "Restarting $process_name..."
        pkill $process_name
        $app_name &
    else
        echo "$app_name is not currently running."
    fi
}

start_application &

inotifywait -q -m -r -e modify,delete,create "$watch_dir" | while read DIRECTORY EVENT FILE; do
    restart_application
done
