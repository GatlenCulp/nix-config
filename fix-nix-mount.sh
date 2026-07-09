#!/bin/bash
# Mount the Nix Store volume at /nix when it fails to mount at boot.
#
# Symptom this fixes: after a reboot, `nix`/`darwin-rebuild` are missing, and
# Nix-managed configs (ghostty, aerospace, etc.) are dangling symlinks into an
# empty /nix. That happens when the FileVault-encrypted "Nix Store" APFS volume
# exists but the boot-time LaunchDaemon (org.nixos.darwin-store) didn't mount it.
#
# The volume's passphrase lives in the system keychain under the name
# "Nix Store" (same source the LaunchDaemon uses), so no password prompt for the
# volume itself -- only sudo needs your login password.
#
# Usage: sudo ./fix-nix-mount.sh   (or just ./fix-nix-mount.sh; it re-execs sudo)

set -euo pipefail

VOLUME_NAME="Nix Store"
MOUNTPOINT="/nix"

# Re-exec under sudo if not already root (mounting at /nix needs privileges).
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Elevating with sudo (mounting at $MOUNTPOINT requires root)..."
    exec sudo "$0" "$@"
fi

# Already mounted? Nothing to do.
if mount | grep -q " on ${MOUNTPOINT} "; then
    echo "✓ ${MOUNTPOINT} is already mounted:"
    mount | grep " on ${MOUNTPOINT} "
    exit 0
fi

# Find the Nix Store volume's device node (e.g. disk3s7).
DEVICE="$(diskutil list | awk -v name="${VOLUME_NAME}" '$0 ~ name {print $NF}' | tail -1)"
if [[ -z "${DEVICE}" ]]; then
    echo "Error: could not find an APFS volume named '${VOLUME_NAME}'." >&2
    echo "Run 'diskutil list' to check whether the Nix Store volume still exists." >&2
    exit 1
fi
echo "Found '${VOLUME_NAME}' at ${DEVICE}."

# Pull the passphrase from the login/system keychain (as the LaunchDaemon does).
# find-generic-password may need the invoking user's keychain, so query as them.
PASSPHRASE="$(sudo -u "${SUDO_USER:-root}" security find-generic-password -s "${VOLUME_NAME}" -w 2>/dev/null || true)"

echo "Mounting '${VOLUME_NAME}' at ${MOUNTPOINT}..."
if [[ -n "${PASSPHRASE}" ]]; then
    # Encrypted + locked: unlock and mount in one step.
    if diskutil apfs unlockVolume "${VOLUME_NAME}" -mountpoint "${MOUNTPOINT}" \
        -passphrase "${PASSPHRASE}" 2>/tmp/fix-nix-mount.err; then
        :
    elif grep -q -- "-69589" /tmp/fix-nix-mount.err; then
        # -69589: volume is already unlocked, so just mount it.
        echo "Volume already unlocked; mounting directly."
        diskutil mount -mountPoint "${MOUNTPOINT}" "${DEVICE}"
    else
        cat /tmp/fix-nix-mount.err >&2
        rm -f /tmp/fix-nix-mount.err
        exit 1
    fi
    rm -f /tmp/fix-nix-mount.err
else
    # No passphrase in keychain (unencrypted or already unlocked): plain mount.
    diskutil mount -mountPoint "${MOUNTPOINT}" "${DEVICE}"
fi

# Verify.
if mount | grep -q " on ${MOUNTPOINT} "; then
    echo "✓ ${MOUNTPOINT} mounted successfully:"
    mount | grep " on ${MOUNTPOINT} "
    echo ""
    echo "Nix should now be available. Open a new shell, or run:"
    echo "  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
else
    echo "Error: mount reported success but ${MOUNTPOINT} is still not mounted." >&2
    exit 1
fi
