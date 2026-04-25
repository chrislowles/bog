#!/usr/bin/env bash
set -euo pipefail

# TODO: refactor this as merging the function of this into the bazaar-cache-reset service

echo "Cleaning up loose Flatpak/Bazaar state..."

# Remove any stale extra installation configs not intentionally placed (keeps system + user, removes ghost entries)
rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

# Flush appstream cache so Bazaar rebuilds it clean on first launch
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

# Refresh appstream data against the current remotes
appstreamcli refresh --force || true

echo "Flatpak/Bazaar state cleanup complete."