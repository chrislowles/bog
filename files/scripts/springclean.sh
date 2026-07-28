#!/usr/bin/env bash
set -euo pipefail

# Applies to the system-wide Flathub remote that Universal Blue images ship pre-configured. Hides blocked app IDs from `flatpak search`, GNOME Software, and any other remote-reading frontend.
flatpak remote-modify --system --filter="/etc/bog/flatpak-filter.txt" flathub

# Removes ghost extra-installation entries not intentionally placed.
rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

# Flushes the appstream cache so Bazaar rebuilds it clean on first launch.
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

# Refresh appstream data against current remotes.
appstreamcli refresh --force || true