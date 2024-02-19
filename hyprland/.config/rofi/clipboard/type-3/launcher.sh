#!/usr/bin/env bash

dir="$HOME/.config/rofi/clipboard/type-3"
theme='style-11'

cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
