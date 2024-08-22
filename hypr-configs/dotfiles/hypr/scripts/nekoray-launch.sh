#!/usr/bin/env bash

if [[ $(pidof nekoray) ]]; then
    pkill nekoray
    pkill nekobox_core
fi

# exec /opt/nekoray/nekoray
exec nekoray
