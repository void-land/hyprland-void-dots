#!/usr/bin/env bash

window_class="floating"

if [[ $(pidof nmtui) ]]; then
    pkill nmtui
fi

exec alacritty --class $window_class -e nmtui
