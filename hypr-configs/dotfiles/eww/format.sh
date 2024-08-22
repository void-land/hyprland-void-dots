#!/bin/bash

WATCH_DIR="$(pwd)"

if [ -z "$WATCH_DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$WATCH_DIR" ]; then
    echo "Directory $WATCH_DIR does not exist."
    exit 1
fi

format_file() {
    local file="$1"
    echo "Formatting $file"
    vim -c "execute 'normal! =G' | :wq!" "$file"
}

last_run=0

inotifywait -m -r -e modify,create,delete,move --format '%w%f' "$WATCH_DIR" | while read -r file; do
    if [[ "$file" == *.yuck ]]; then
        current_time=$(date +%s%N | cut -b1-13)

        if ((current_time - last_run > 2500)); then
            sleep 0.1
            if [ -e "$file" ]; then
                format_file $file
            fi
            last_run=$current_time
        fi
    fi
done
