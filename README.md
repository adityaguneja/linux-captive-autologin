# Linux Captive Portal Auto-Login & Keep-Alive

Network logouts can be quite frustrating, especially when your 103 gig shady website download fails because your campus wifi timed out. This tool fixes that: a lightweight automation utility for Linux systems to allow instant reconnects to your campus or enterprise wifi.

## Features

- **No hardcoded credentials**: Securely loads from `~/.config/autologin/credentials.env` with restricted user-only permissions (`0600`).
- **SSID Guardrail**: Checks the active Wi-Fi name before executing. Your credentials are never broadcast over untrusted mobile hotspots or public networks.
- **Instant Reconnect**: NetworkManager dispatcher hook triggers authentication immediately when the Wi-Fi interface associates.
- **Session Keep-Alive**: Background `systemd --user` timer probes connectivity every 5 minutes and refreshes stale or dropped sessions automatically.

---

## Installation

Works on any Linux distribution with `bash`, `curl`, and `NetworkManager`.

```bash
# 1. Clone the repository
git clone [https://github.com/](https://github.com/)adityaguneja/linux-captive-autologin.git

# 2. Enter the directory
cd linux-captive-autologin

# 3. Make installer executable and run
chmod +x install.sh
./install.sh
```

## Configuration
After running ./install.sh, open your local credentials file:
```bash
nano ~/.config/autologin/credentials.env
```
## Gateway credentials & endpoint
PORTAL_USER="your_username"  
PORTAL_PASS="your_password"  
PORTAL_URL="[https://10.1.0.1:8090/httpclient.html](https://10.1.0.1:8090/httpclient.html)"  

Space-separated list of trusted SSIDs (leave blank to bypass check)
ALLOWED_SSIDS="Campus-WiFi BITS-Pilani Hostel-5G"

## Optional: Instant Wi-Fi Reconnect Hook
By default, the systemd user watchdog verifies connection status every 5 minutes. If you want authentication to fire instantly when your wifi connects
```bash
sudo install -m 0755 dispatcher/99-autologin.sh /etc/NetworkManager/dispatcher.d/
```

## Verification 
Check the status of the background timer:
```bash
systemctl --user status autologin.timer
```
Run a manual test to verify credentials and connectivity checks:
```bash
bash -x ~/.local/bin/autologin
```
