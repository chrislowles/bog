#!/usr/bin/env bash
set -euo pipefail

FILTER_SRC="/etc/bog/flatpak-filter.txt"

# Applies to the system-wide Flathub remote that Universal Blue images
# ship pre-configured. Hides blocked app IDs from `flatpak search`,
# GNOME Software, and any other remote-reading frontend.
flatpak remote-modify --system --filter="${FILTER_SRC}" flathub