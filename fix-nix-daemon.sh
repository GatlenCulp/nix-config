#!/bin/bash
# Restart the nix-daemon when it isn't accepting connections.
#
# Symptom this fixes: nix/darwin-rebuild fail with
#   error: cannot connect to socket at '/nix/var/nix/daemon-socket/socket':
#   Connection refused
# That means the multi-user nix-daemon LaunchDaemon isn't running (crashed,
# was booted out, or never came up after a reboot). Note: if /nix itself is
# empty/unmounted, run ./fix-nix-mount.sh first -- the daemon can't start
# without the store volume.
#
# Usage: sudo ./fix-nix-daemon.sh   (or just ./fix-nix-daemon.sh; it re-execs sudo)

set -euo pipefail

PLIST="/Library/LaunchDaemons/org.nixos.nix-daemon.plist"
SERVICE="system/org.nixos.nix-daemon"
SOCKET="/nix/var/nix/daemon-socket/socket"

# Re-exec under sudo if not already root (launchctl on system domain needs it).
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Elevating with sudo (managing the system launchd domain requires root)..."
    exec sudo "$0" "$@"
fi

# The daemon can't run if the Nix Store volume isn't mounted.
if [[ ! -d /nix/store ]]; then
    echo "Error: /nix/store is missing -- the Nix Store volume is likely unmounted." >&2
    echo "Run ./fix-nix-mount.sh first, then re-run this script." >&2
    exit 1
fi

if [[ ! -f "${PLIST}" ]]; then
    echo "Error: ${PLIST} not found; nix-daemon isn't installed as a LaunchDaemon." >&2
    exit 1
fi

# Unload any existing (possibly wedged) instance. Ignore failure if not loaded.
echo "Booting out any existing nix-daemon service..."
launchctl bootout "${SERVICE}" 2>/dev/null || true

# Load the daemon back into the system domain.
echo "Bootstrapping nix-daemon from ${PLIST}..."
launchctl bootstrap system "${PLIST}"

# Force (re)start so it comes up immediately.
echo "Kickstarting nix-daemon..."
launchctl kickstart -k "${SERVICE}"

# Verify the socket is accepting connections (give it a moment to bind).
echo "Waiting for ${SOCKET}..."
for _ in $(seq 1 10); do
    if [[ -S "${SOCKET}" ]]; then
        echo "✓ nix-daemon is running and ${SOCKET} is present."
        echo ""
        echo "You can now retry your rebuild, e.g.:"
        echo "  sudo darwin-rebuild switch --flake ~/.config/nix-config --impure"
        exit 0
    fi
    sleep 1
done

echo "Error: nix-daemon was (re)started but ${SOCKET} did not appear." >&2
echo "Check logs with: sudo launchctl print ${SERVICE}" >&2
exit 1
