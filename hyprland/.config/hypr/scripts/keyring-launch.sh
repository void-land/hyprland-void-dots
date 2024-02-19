#!/usr/bin/env bash

exec gnome-keyring-daemon -sd &
exec /usr/libexec/polkit-gnome-authentication-agent-1
