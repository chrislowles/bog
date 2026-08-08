#!/usr/bin/env bash
set -euo pipefail

FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"

echo "springclean-user: Re/applying filter to flathub remote"
flatpak remote-modify --user --filter="${FLATHUB_FILTER}" flathub 2>/dev/null || true

echo "springclean-user: Documenting post-apply state for debugging"
flatpak remote-info --user flathub | grep -i filter || echo " (no filter field found immediately after applying)"

echo "springclean-user: Killing the running Bazaar process and clearing its cache to force a rebuild against the current filter state."
pkill -u "${USER}" -f '(^|/)bazaar$' 2>/dev/null || true
rm -rf "${HOME}/.cache/bazaar" 2>/dev/null || true
rm -rf "${HOME}/.cache/io.github.kolunmi.Bazaar" 2>/dev/null || true