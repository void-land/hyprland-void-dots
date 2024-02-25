#!/usr/bin/env bash

if [[ $(pidof wpa-cute) ]]; then
    pkill -f wpa-cute
fi

exec wpa-cute
