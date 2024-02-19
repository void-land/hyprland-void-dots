#!/usr/bin/env bash

dir="$HOME/.config/rofi/clipboard/type-1"
theme='style-8'

cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
