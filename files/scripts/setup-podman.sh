#!/usr/bin/env bash
set -euo pipefail

echo "Configuring Podman for rootless operation..."

# Enable lingering so user services start at boot without login
# This runs at build time so it targets the skel
# Actual loginctl linger enable needs to happen per-user at first login (see profile.d)

# TODO: see if I can just move this into common.yml

# Ensure podman auto-update timer is enabled globally
systemctl --global enable podman-auto-update.timer

echo "Podman setup complete."