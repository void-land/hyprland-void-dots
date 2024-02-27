#!/usr/bin/env bash

window_class="floating"

exec alacritty --class $window_class -e nmtui
