#!/bin/bash

create_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ]; then
        echo "Source directory does not exist."
        return 1
    fi

    if [ ! -d $target_dir ]; then
        mkdir -p $target_dir
    fi

    for item in "$source_dir"/* "$source_dir"/.*; do
        if [ -e "$item" ] && [ "$item" != "$source_dir/." ] && [ "$item" != "$source_dir/.." ]; then
            echo "$item ===> $target_dir"

            ln -sfn "$item" "$target_dir/"
        fi
    done
}

delete_links() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d $source_dir ] || [ ! -d $target_dir ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for config in "$source_dir"/* "$source_dir"/.*; do
        config_name=$(basename $config)
        target_config="$target_dir/$config_name"

        if [ -e "$target_config" ]; then
            rm -rf $target_config
            echo "Removed: $target_config"
        else
            echo "Not found: $target_config"
        fi
    done
}
