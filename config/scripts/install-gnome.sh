#!/usr/bin/bash
set -euo pipefail

echo "Installing minimal GNOME desktop environment..."

# Install minimal GNOME packages
rpm-ostree install \
    gnome-shell \
    gdm \
    gnome-terminal \
    gnome-control-center \
    gnome-system-monitor \
    nautilus \
    gnome-text-editor \
    gnome-calculator \
    gnome-tweaks \
    gnome-browser-connector

# Optional: Install additional GNOME utilities
rpm-ostree install \
    gnome-extensions-app \
    dconf-editor

echo "GNOME installation complete."