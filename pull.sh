#!/bin/bash

git_pull() {
    if [[ "$1" == "-p" ]]; then
        git stash
        git pull
        git stash pop
    else
        git pull
    fi
}

git_pull_submodule() {
    if [[ "$1" == "-s" ]]; then
        git submodule update --recursive --remote
        git submodule foreach git checkout main
        git submodule foreach git pull origin main
    else
        echo "Usage: $0 -s"
    fi
}

while getopts "ps" opt; do
    case $opt in
    p)
        git_pull -p
        ;;
    s)
        git_pull_submodule -s
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

if [[ $# -eq 0 ]]; then
    git_pull
fi
