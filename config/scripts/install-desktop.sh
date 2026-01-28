#!/usr/bin/bash

rpm-ostree install \
	NetworkManager-wifi NetworkManager-wwan NetworkManager-tui \
	gnome-shell gdm gnome-session gnome-settings-daemon gnome-keyring xdg-desktop-portal-gnome xdg-user-dirs-gtk \
	gnome-terminal gnome-control-center gnome-system-monitor nautilus gnome-text-editor gnome-disk-utility gnome-logs baobab dconf-editor \
	gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free \
	google-noto-sans-fonts google-noto-serif-fonts google-noto-emoji-fonts liberation-fonts