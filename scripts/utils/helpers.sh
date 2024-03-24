#!/bin/bash

create_symlinks() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d "$source_dir" ] || [ ! -d "$target_dir" ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for item in "$source_dir"/* "$source_dir"/.*; do
        [ -e "$item" ] && [ "$item" != "$source_dir/." ] && [ "$item" != "$source_dir/.." ] && ln -sfn "$item" "$target_dir/"
    done
}

delete_symlinks() {
    local source_dir=$1
    local target_dir=$2

    if [ ! -d "$source_dir" ] || [ ! -d "$target_dir" ]; then
        echo "Source or target directory does not exist."
        return 1
    fi

    for config in $source_dir/*; do
        config_name=$(basename $config)
        target_config=$target_dir/$config_name

        if [ -e $target_config ]; then
            rm -rf $target_config
            echo "Removed: $target_config"
        else
            echo "Not found: $target_config"
        fi
    done
}
