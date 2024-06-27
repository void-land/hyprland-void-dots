#!/bin/bash
confPath="$HOME/.config/eww/carbonmonoxide/scripts/cava_config"

# Main
cava -p $confPath | while read -r line; do echo $line| sed -e 's/;/,/g'; done | while read -r line; do echo "["`echo ${line/%?/}`"]"; done
