#!/usr/bin/env bash
set -euo pipefail

FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"

echo "springclean-system: applying filter to flathub"
flatpak remote-modify --system --filter="${FLATHUB_FILTER}" flathub

echo "springclean-system: post-apply state:"
flatpak remote-info --system flathub | grep -i filter || echo "  (no filter field found immediately after applying)"

rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true
appstreamcli refresh --force || true