#!/usr/bin/bash
set -euo pipefail

echo "Configuring Flatpak..."

# Ensure Flatpak is installed
rpm-ostree install flatpak

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install essential Flatpak applications (optional)
# Uncomment the ones you want pre-installed:
# flatpak install -y flathub org.mozilla.firefox
# flatpak install -y flathub org.gnome.Extensions

echo "Flatpak configuration complete."