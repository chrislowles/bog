#!/usr/bin/bash

echo "Configuring Flatpak..."

# Flatpak should already be installed in the base image, but ensure it's present
# Don't fail if it's already installed
set +e
rpm-ostree install flatpak 2>/dev/null
flatpak_result=$?
set -e

if [ $flatpak_result -eq 0 ]; then
    echo "Flatpak installed successfully"
else
    echo "Flatpak already present or installation not needed"
fi

# Flathub remote will be added at runtime by the system
# We can't add remotes or install flatpaks during the image build
# Users will add flathub and install flatpaks after booting

echo "Flatpak configuration complete."
echo "Note: Flathub remote and flatpaks will be configured at first boot or by user"