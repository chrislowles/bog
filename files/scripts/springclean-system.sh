#!/usr/bin/env bash
set -euo pipefail

FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"
flatpak remote-modify --system --filter="${FLATHUB_FILTER}" flathub

rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

appstreamcli refresh --force || true