#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-2"
theme='style-6'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
