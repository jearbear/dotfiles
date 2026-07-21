#!/usr/bin/env bash
set -euo pipefail

NAME="Jerry's AirPods Pro"

# Find the MAC address for the device by its alias.
MAC=$(bluetoothctl devices | awk -v name="$NAME" '
    {
        mac = $2
        $1 = ""; $2 = ""
        sub(/^[ \t]+/, "")
        if ($0 == name) { print mac; exit }
    }
')

if [[ -z "${MAC:-}" ]]; then
    notify-send "Bluetooth" "Device '$NAME' not found (not paired?)" 2>/dev/null || true
    exit 1
fi

# Make sure the controller is powered on.
if ! bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power on >/dev/null
fi

if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$MAC" >/dev/null
    notify-send "Bluetooth" "Disconnected $NAME" 2>/dev/null || true
else
    bluetoothctl connect "$MAC" >/dev/null &&
        notify-send "Bluetooth" "Connected $NAME" 2>/dev/null ||
        notify-send "Bluetooth" "Failed to connect $NAME" 2>/dev/null || true
fi
