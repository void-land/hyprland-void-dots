#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

files=($(find "${wallpapers_dir}" -type f))

if [ ${#files[@]} -eq 0 ]; then
    echo "No files found in the directory: ${wallpapers_dir}"
    exit 1
fi

image_files=()
for file in "${files[@]}"; do
    if file -b --mime-type "$file" | grep -q "^image/"; then
        image_files+=("$file")
    fi
done

if [ ${#image_files[@]} -eq 0 ]; then
    echo "No image files found in the directory: ${wallpapers_dir}"
    exit 1
fi

random_pic=${image_files[$RANDOM % ${#image_files[@]}]}

swww img "$random_pic" --transition-fps $swww_fps --transition-type any --transition-duration $swww_duration
