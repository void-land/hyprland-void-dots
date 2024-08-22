#!/usr/bin/env bash

if [[ $(pidof wpa-cute) ]]; then
    pkill wpa-cute
fi

exec wpa-cute
