#!/usr/bin/env bash

cliphist list | rofi -dmenu | cliphist decode | wl-copy
