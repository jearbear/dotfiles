#!/usr/bin/env bash
set -euo pipefail

TARGET="Sugo DNS"

# Bring down any currently active WireGuard tunnels first so we don't end up
# with overlapping tunnels.
mapfile -t active < <(nmcli -t -f NAME,TYPE connection show --active | awk -F: '$2 == "wireguard" { print $1 }')

already_up=0
for conn in "${active[@]}"; do
    if [[ "$conn" == "$TARGET" ]]; then
        already_up=1
    fi
    nmcli connection down "$conn" >/dev/null || true
done

refresh() {
    pkill -RTMIN+8 waybar 2>/dev/null || true
}
trap refresh EXIT

if (( already_up )); then
    notify-send "WireGuard" "Disconnected $TARGET" 2>/dev/null || true
    exit 0
fi

if nmcli connection up "$TARGET" >/dev/null; then
    notify-send "WireGuard" "Connected $TARGET" 2>/dev/null || true
else
    notify-send "WireGuard" "Failed to connect $TARGET" 2>/dev/null || true
    exit 1
fi
