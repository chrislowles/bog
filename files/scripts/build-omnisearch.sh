#!/usr/bin/env bash
set -oue pipefail

echo "Building OmniSearch from source..."

echo "Installing build dependencies..."
dnf install -y \
    git \
    make \
    gcc \
    libxml2-devel \
    libcurl-devel \
    openssl-devel

echo "Building beaker (OmniSearch dependency)..."
cd /tmp
git clone https://git.bwaaa.monster/beaker
cd beaker
make
make install

echo "Building OmniSearch..."
cd /tmp
git clone https://git.bwaaa.monster/omnisearch
cd omnisearch

# Pre-create directories that the Makefile expects but doesn't always mkdir
mkdir -p /var/lib/omnisearch /var/log/omnisearch /var/cache/omnisearch /etc/omnisearch

echo "Installing OmniSearch..."
make install-systemd

echo "Cleaning up build-only dependencies..."
dnf remove -y \
    git \
    make \
    gcc \
    libxml2-devel \
    libcurl-devel \
    openssl-devel

dnf clean all

echo ""
echo "============================================"
echo "OmniSearch build complete!"
echo "============================================"
echo "Config: /etc/omnisearch/config.ini"
echo "Service: omnisearch.service (system)"
echo "Enable with: sudo systemctl enable --now omnisearch"
echo "============================================"