#!/usr/bin/bash
set -euo pipefail

echo "Configuring Flatpak..."

# Flatpak should already be installed in the base image, but ensure it's present
rpm-ostree install flatpak || echo "Flatpak already installed"

# Flathub remote will be added at runtime by the system
# We can't add remotes or install flatpaks during the image build
# Users will add flathub and install flatpaks after booting

echo "Flatpak configuration complete."
echo "Note: Flathub remote and flatpaks will be configured at first boot or by user"