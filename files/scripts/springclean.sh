#!/usr/bin/env bash
set -euo pipefail

echo "=== SPRING CLEANING AT YOUR SERVICE ==="

echo "Taking care of Flatpak..."

# ── Stale Flatpak installation configs ────────────────────────────────────────
# Removes ghost extra-installation entries not intentionally placed.
echo "Removing stale Flatpak installation configs..."
rm -f /etc/flatpak/installations.d/*.conf 2>/dev/null || true
rm -f /usr/share/flatpak/installations.d/*.conf 2>/dev/null || true

# ── Appstream cache ────────────────────────────────────────────────────────────
# Flushes the appstream cache so Bazaar rebuilds it clean on first launch.
echo "Flushing appstream cache..."
rm -rf /var/cache/app-info/xmls/ 2>/dev/null || true
rm -rf /var/cache/app-info/icons/ 2>/dev/null || true

# Refresh appstream data against current remotes.
appstreamcli refresh --force || true

echo "=== SPRING CLEANING DONE ==="