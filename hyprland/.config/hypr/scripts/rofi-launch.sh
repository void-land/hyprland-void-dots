#!/usr/bin/env bash

source $HOME/.config/hypr/scripts/env.sh

case $1 in
d) exec $rofi_dir/launchers/type-$launcher_type/launcher.sh ;;
p) exec $rofi_dir/applets/bin/powermenu.sh ;;
s) exec $rofi_dir/applets/bin/screenshot.sh ;;
h)
    echo -e "rofilaunch.sh [action]\nwhere action,"
    echo "d : drun mode"
    echo "w : window mode"
    echo "s : screen shot mode,"
    exit 0
    ;;
*) ;;
esac
