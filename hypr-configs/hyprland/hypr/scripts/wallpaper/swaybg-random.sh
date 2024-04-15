#!/usr/bin/env bash

source ~/.config/scripts/env.sh

files=($(find "${WALLPAPERS_DIR}" -type f))

if [ ${#files[@]} -eq 0 ]; then
    dunstify "No files found in the directory: ${WALLPAPERS_DIR}"
    exit 1
fi

image_files=()
for file in "${files[@]}"; do
    if file -b --mime-type "$file" | grep -q "^image/"; then
        image_files+=("$file")
    fi
done

if [ ${#image_files[@]} -eq 0 ]; then
    dunstify "No image files found in the directory: ${WALLPAPERS_DIR}"
    exit 1
fi

random_pic=${image_files[$RANDOM % ${#image_files[@]}]}

if [[ $(pidof swaybg) ]]; then
    pkill swaybg
fi

swaybg -i "$random_pic"
