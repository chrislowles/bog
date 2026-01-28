#!/usr/bin/bash
echo "Configuring Flatpak with Flathub..."

echo "Adding Flathub repository system-wide"
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Enabling Flathub by default"
flatpak remote-modify --enable flathub

echo "Flatpak configuration complete."

echo "Flathub is now available at first boot."