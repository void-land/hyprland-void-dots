#!/bin/bash

source ./utils.sh

FONTS_DIR="../configs/host/ui/fonts"

install_ttf_fonts() {
   sudo cp *.ttf /usr/share/fonts/TTF
   sudo fc-cache -f -v

   log "Fonts installed successfully!"
}

check_sudo

cd $FONTS_DIR
install_ttf_fonts
