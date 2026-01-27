#!/usr/bin/bash
set -euo pipefail

echo "Installing minimal GNOME desktop environment..."

# Install GNOME Desktop group and essential packages
rpm-ostree install \
    @gnome-desktop \
    gdm \
    gnome-terminal \
    gnome-control-center \
    gnome-system-monitor \
    nautilus \
    gnome-text-editor \
    gnome-browser-connector \
    dconf-editor

echo "GNOME installation complete."