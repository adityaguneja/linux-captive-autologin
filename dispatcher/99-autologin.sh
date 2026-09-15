#!/usr/bin/env bash
# NetworkManager dispatcher - works in sync with the keep alive units to allow for instant reconnects
INTERFACE="$1"
ACTION="$2"

if [[ "$ACTION" == "up" ]]; then
    # Run user autologin script if user session is active
    USER_NAME=$(loginctl list-users --no-legend | awk '{print $2}' | head -n 1)
    if [[ -n "$USER_NAME" ]]; then
        USER_HOME=$(eval echo "~$USER_NAME")
        if [[ -x "$USER_HOME/.local/bin/autologin" ]]; then
            su "$USER_NAME" -c "$USER_HOME/.local/bin/autologin" &
        fi
    fi
fi
