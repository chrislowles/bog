#!/usr/bin/env bash
set -oue pipefail

echo "Building custom Bazaar from source with blocklist..."

# Install build dependencies
echo "Installing build dependencies..."
dnf install -y \
    git \
    meson \
    ninja-build \
    gcc \
    pkgconfig \
    gtk4-devel \
    libadwaita-devel \
    libdex-devel \
    flatpak-devel \
    appstream-devel \
    json-glib-devel \
    libsoup3-devel \
    libxmlb-devel \
    libyaml-devel \
    blueprint-compiler \
    desktop-file-utils \
    glycin-devel \
    glycin-gtk4-devel \
    md4c-devel

BAZAAR_VERSION="v0.7.8"
echo "Cloning Bazaar ${BAZAAR_VERSION}..."
cd /tmp
git clone --depth 1 --branch ${BAZAAR_VERSION} https://github.com/kolunmi/bazaar.git
cd bazaar

# Build with custom config that points to /etc/bazaar/main.yaml
# This file is already installed via the files module
echo "Building Bazaar with custom configuration..."
meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dhardcoded_main_config_path=/etc/bazaar/main.yaml

ninja -C build

echo "Installing Bazaar..."
ninja -C build install

# The config files (main.yaml, blocklist.yaml, curated.yaml) are already
# installed to /etc/bazaar/ via the files module, so we don't need to copy them

# Compile gschema
echo "Compiling gschema..."
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Clean up build dependencies to keep image size down
echo "Cleaning up build dependencies..."
dnf remove -y \
    git \
    meson \
    ninja-build \
    gcc \
    gtk4-devel \
    libadwaita-devel \
    libdex-devel \
    flatpak-devel \
    appstream-devel \
    json-glib-devel \
    libsoup3-devel \
    libxmlb-devel \
    libyaml-devel \
    blueprint-compiler

dnf clean all

echo "Bazaar custom build complete!"
echo "  - Configuration: /etc/bazaar/main.yaml"
echo "  - Blocklist: /etc/bazaar/blocklist.yaml"
echo "  - Curated content: /etc/bazaar/curated.yaml"
echo ""
echo "To modify blocklist or curated content, edit the files in:"
echo "  files/system/etc/bazaar/"