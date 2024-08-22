#!/usr/bin/env bash

source ~/.config/scripts/env.sh

pkill rofi

case $1 in
d) exec $ROFI_DIR/launchers/type-$LAUNCHER_TYPE/launcher.sh ;;
c) exec $ROFI_DIR/clipboard/type-$CLIPBOARD_TYPE/clipboard.sh ;;
w) exec $ROFI_DIR/wallpaper/type-$WALLPAPER_TYPE/wallpaper.sh ;;
p) exec $ROFI_DIR/applets/bin/powermenu.sh ;;
s) exec $ROFI_DIR/applets/bin/screenshot.sh ;;
h)
    echo -e "rofilaunch.sh [action]\nwhere action,"
    echo "d : drun mode"
    echo "w : window mode"
    echo "s : screen shot mode,"
    echo "c : clipboard manager"
    exit 0
    ;;
*) ;;
esac
