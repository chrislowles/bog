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
    gnome-browser-connector \
    dconf-editor

echo "GNOME installation complete."