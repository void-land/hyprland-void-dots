#!/usr/bin/env bash

if ! pgrep -x "eww" >/dev/null; then
    eww daemon &
    sleep 1
fi

eww open bar
eww open notifications
