#!/usr/bin/env bash
set -euo pipefail

FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"
flatpak remote-modify --user --filter="${FLATHUB_FILTER}" flathub 2>/dev/null || true

# Bazaar runs as a persistent background service and caches its catalog, a plain relaunch won't pick up filter changes, only killing the running process and clearing its cache forces a rebuild against the current filter state.
pkill -u "${USER}" -f '(^|/)bazaar$' 2>/dev/null || true
rm -rf "${HOME}/.cache/bazaar" 2>/dev/null || true
rm -rf "${HOME}/.cache/io.github.kolunmi.Bazaar" 2>/dev/null || true