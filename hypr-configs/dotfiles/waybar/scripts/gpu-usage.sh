#!/usr/bin/env bash

file_exists() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

device_id="0"
gpu_busy_file="/sys/class/hwmon/hwmon$device_id/device/gpu_busy_percent"

if file_exists "$gpu_busy_file"; then
    gpu_busy_percent=$(cat "$gpu_busy_file")
    echo "$gpu_busy_percent"
else
    echo "Error !" >&2
    exit 1
fi
