#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/autologin"
SYSTEMD_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

echo "Installing..."
mkdir -p "$BIN_DIR"
install -m 0755 bin/autologin.sh "$BIN_DIR/autologin"

mkdir -p "$CONFIG_DIR"
if [[ ! -f "$CONFIG_DIR/credentials.env" ]]; then
    cp config.example.env "$CONFIG_DIR/credentials.env"
    chmod 0600 "$CONFIG_DIR/credentials.env"
    echo "  -> Created $CONFIG_DIR/credentials.env. Edit this file with your credentials!"
else
    echo "  -> $CONFIG_DIR/credentials.env already exists, skipping overwrite."
fi


mkdir -p "$SYSTEMD_DIR"
install -m 0644 systemd/* "$SYSTEMD_DIR/"
systemctl --user daemon-reload
systemctl --user enable --now autologin.timer

echo "Optional: NetworkManager dispatcher hook"
echo "To auto-login immediately on Wi-Fi connection, run:"
echo "  sudo cp dispatcher/99-autologin.sh /etc/NetworkManager/dispatcher.d/"
echo "  sudo chmod +x /etc/NetworkManager/dispatcher.d/99-autologin.sh"
echo ""
echo "Installation complete!"
