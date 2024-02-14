#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

# Get only files from the directory
files=($(find "${wallpapers_dir}" -type f))

# Check if there are any files
if [ ${#files[@]} -eq 0 ]; then
    echo "No files found in the directory: ${wallpapers_dir}"
    exit 1
fi

# Filter files to include only those identified as images by the 'file' command
image_files=()
for file in "${files[@]}"; do
    if file -b --mime-type "$file" | grep -q "^image/"; then
        image_files+=("$file")
    fi
done

# Check if there are any image files
if [ ${#image_files[@]} -eq 0 ]; then
    echo "No image files found in the directory: ${wallpapers_dir}"
    exit 1
fi

# Get a random image from the array
random_pic=${image_files[$RANDOM % ${#image_files[@]}]}

echo $random_pic

swww img "$random_pic" --transition-fps $swww_fps --transition-type any --transition-duration $swww_duration
