#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/autologin/credentials.env"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found at $CONFIG_FILE" >&2
    echo "Copy config.example.env to $CONFIG_FILE and update credentials." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

# Check if connected to target Wi-Fi SSID
CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || true)

if [[ -n "${TARGET_SSID:-}" && "$CURRENT_SSID" != "$TARGET_SSID" ]]; then
    exit 0
fi

# Check if Internet is already accessible
if curl -s --connect-timeout 2 http://connectivity-check.ubuntu.com >/dev/null 2>&1; then
    exit 0
fi

# Authenticate captive portal
curl -s -k -X POST "$PORTAL_URL" \
    --data-urlencode "mode=191" \
    --data-urlencode "username=$PORTAL_USER" \
    --data-urlencode "password=$PORTAL_PASS" \
    --data-urlencode "a=$(date +%s%3N)" >/dev/null 2>&1 || true
