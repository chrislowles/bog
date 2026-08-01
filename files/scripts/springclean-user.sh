#!/usr/bin/env bash
set -euo pipefail

FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"
flatpak remote-modify --user --filter="${FLATHUB_FILTER}" flathub 2>/dev/null || true