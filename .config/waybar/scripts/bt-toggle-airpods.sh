#!/usr/bin/env bash
set -euo pipefail

NAME="AirPods"
MAC=$(bluetoothctl devices | grep "$NAME" | head | cut -d ' ' -f 2)

if [[ -z "${MAC:-}" ]]; then
    notify-send "Bluetooth" "Device '$NAME' not found (not paired?)"
    exit 1
fi

if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    bluetoothctl power off
    notify-send "Bluetooth" "Disconnected $NAME"
else
    bluetoothctl power on
    if bluetoothctl connect "$MAC"; then
        notify-send "Bluetooth" "Connected $NAME"
    else
        notify-send "Bluetooth" "Failed to connect $NAME"
    fi
fi
