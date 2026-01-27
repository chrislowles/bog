#!/usr/bin/bash

echo "Configuring Flatpak..."

# Flatpak is already installed in the base image
# We can't add remotes or install flatpaks during the image build
# Users will add flathub and install flatpaks after booting

echo "Flatpak configuration complete."
echo "Note: Flathub remote and flatpaks will be configured at first boot or by user"