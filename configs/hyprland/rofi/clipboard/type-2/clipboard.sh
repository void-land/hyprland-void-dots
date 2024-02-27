#!/usr/bin/env bash

dir="$HOME/.config/rofi/clipboard/type-2"
theme='style'

cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
