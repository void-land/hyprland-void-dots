#!/bin/bash

source ../utils/main.sh

DOWNLOAD_URL="https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-3.26-2023-12-09-linux64.zip"
FILE_NAME="nekoray.zip"

install_nekoray() {
    download_file $DOWNLOAD_URL $FILE_NAME
}

install_nekoray
