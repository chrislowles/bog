#!/usr/bin/bash

echo "Installing topgrade for unified system upgrading"
rpm-ostree install topgrade

echo "Installing base for system operations"
rpm-ostree install NetworkManager-wifi NetworkManager-wwan NetworkManager-tui

echo "Installing base for minimal GNOME desktop environment"
rpm-ostree install gnome-shell gdm gnome-session gnome-settings-daemon gnome-keyring xdg-desktop-portal-gnome xdg-user-dirs-gtk

echo "Installing base GNOME applications"
rpm-ostree install gnome-terminal gnome-control-center gnome-system-monitor nautilus gnome-text-editor gnome-disk-utility gnome-logs baobab dconf-editor

echo "Installing gstreamer plugins"
rpm-ostree install gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free

echo "Installing fonts"
rpm-ostree install google-noto-sans-fonts google-noto-serif-fonts google-noto-emoji-fonts liberation-fonts

echo "GNOME installation complete."