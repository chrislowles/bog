#!/usr/bin/bash
echo "Configuring Flatpak with Flathub..."
# Add Flathub repository system-wide
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# Enable Flathub by default
flatpak remote-modify --enable flathub
echo "Flatpak configuration complete."
echo "Flathub is now available at first boot."