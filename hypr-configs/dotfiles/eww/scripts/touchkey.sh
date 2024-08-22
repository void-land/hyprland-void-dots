#!/bin/sh

PID=$(pidof wvkbd-mobintl)

if [ -z $PID ]; then
    wvkbd-mobintl &
else 
    kill $PID
fi
