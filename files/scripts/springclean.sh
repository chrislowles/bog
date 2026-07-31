#!/usr/bin/env bash
set -euo pipefail

# Applies to the Flathub remotes that Universal Blue images ship pre-configured. Hides blocked app IDs from `flatpak search`, Bazaar, and any other remote-reading frontend.
FLATHUB_FILTER="/etc/bog/flatpak-filter.txt"
flatpak remote-modify --system --filter="${FLATHUB_FILTER}" flathub
flatpak remote-modify --user --filter="${FLATHUB_FILTER}" flathub 2>/dev/null || true

# Removes ghost extra-installation entries not intentionally placed.
rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

# Flushes the appstream cache so Bazaar rebuilds it clean on first launch.
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

# Refresh appstream data against current remotes.
appstreamcli refresh --force || true