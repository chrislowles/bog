#!/usr/bin/env bash
set -euo pipefail

# Clears the Bazaar runtime cache on each session start so it rebuilds cleanly.
rm -rf "${HOME}/.var/app/io.github.kolunmi.Bazaar/cache/"

# Removes ghost extra-installation entries not intentionally placed.
rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

# Flushes the appstream cache so Bazaar rebuilds it clean on first launch.
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

# Refresh appstream data against current remotes.
appstreamcli refresh --force || true