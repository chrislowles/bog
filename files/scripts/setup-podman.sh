#!/usr/bin/env bash
set -oue pipefail

echo "Configuring Podman for rootless operation..."

# Enable lingering so user services start at boot without login
# This runs at build time so it targets the skel — actual loginctl
# linger enable needs to happen per-user at first login (see profile.d)

# Ensure podman auto-update timer is enabled globally
systemctl --global enable podman-auto-update.timer

echo "Podman setup complete."