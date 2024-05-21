#!/bin/bash

git_pull() {
    git pull
}

git_pull_submodule() {
    git submodule update --recursive --remote
    git submodule foreach git checkout main
    git submodule foreach git pull origin main
}

git_pull
git_pull_submodule
