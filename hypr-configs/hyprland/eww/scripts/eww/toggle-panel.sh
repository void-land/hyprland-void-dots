#!/usr/bin/env bash

current_state=$(eww get revealControlpanel)

if [ "$current_state" = "true" ]; then
    new_state="false"
else
    new_state="true"
fi

eww update revealControlpanel="$new_state"
