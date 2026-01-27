#!/usr/bin/bash
set -euo pipefail

echo "Configuring Flatpak..."

# Ensure Flatpak is installed
rpm-ostree install flatpak

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install essential Flatpak applications
flatpak install -y flathub org.mozilla.firefox

echo "Flatpak configuration complete."