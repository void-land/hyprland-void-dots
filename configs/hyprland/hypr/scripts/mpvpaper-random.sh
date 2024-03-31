#!/usr/bin/env bash

source ~/.config/scripts/env.sh

files=($(find "${LIVE_WALLPAPERS_DIR}" -type f))

if [ ${#files[@]} -eq 0 ]; then
    dunstify "No files found in the directory: ${LIVE_WALLPAPERS_DIR}"
    exit 1
fi

video_files=()
for file in "${files[@]}"; do
    if file -b --mime-type "$file" | grep -q "^video/"; then
        video_files+=("$file")
    fi
done

if [ ${#video_files[@]} -eq 0 ]; then
    echo "No video files found in the directory: ${WALLPAPERS_DIR}"
    exit 1
fi

random_video=${video_files[$RANDOM % ${#video_files[@]}]}

if [[ $(pidof mpvpaper) ]]; then
    pkill mpvpaper
fi

mpvpaper -o "loop-file" "*" $random_video
