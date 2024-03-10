#!/usr/bin/env bash

if [[ $(pidof nekoray) ]]; then
    pkill -f nekoray
fi

exec /opt/nekoray/nekoray
