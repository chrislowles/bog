#!/usr/bin/bash

echo "Installing minimal GNOME desktop environment..."

rpm-ostree install \
	gnome-shell \
	gdm \
	gnome-session \
	gnome-settings-daemon \
	gnome-terminal \
	gnome-control-center \
	gnome-system-monitor \
	nautilus \
	gnome-text-editor \
	gnome-disk-utility \
	gnome-logs \
	baobab \
	dconf-editor \
	xdg-desktop-portal-gnome \
	xdg-user-dirs-gtk \
	gnome-keyring \
	NetworkManager-wifi \
	NetworkManager-wwan \
	gstreamer1-plugins-base \
	gstreamer1-plugins-good \
	gstreamer1-plugins-bad-free \
	google-noto-sans-fonts \
	google-noto-serif-fonts \
	google-noto-emoji-fonts \
	liberation-fonts

echo "GNOME installation complete."