#!/usr/bin/env bash
set -euo pipefail

# Print the name of the currently active WireGuard tunnel managed by
# NetworkManager, or "n/a" if none is active.

active=$(nmcli -t -f NAME,TYPE connection show --active | awk -F: '$2 == "wireguard" { print $1; exit }')

if [[ -n "$active" ]]; then
    printf '%s\n' "$active"
else
    printf 'n/a\n'
fi
