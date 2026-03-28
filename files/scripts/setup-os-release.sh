#!/usr/bin/env bash
set -oue pipefail

# Read the Fedora version from the base image's os-release
source /usr/lib/os-release
FEDORA_VERSION="${VERSION_ID}"

# Append/override the fields we want
# Use a temp file to avoid partial writes
cp /usr/lib/os-release /tmp/os-release.tmp

# Replace or append key fields
sed -i "s|^NAME=.*|NAME=\"bog\"|" /tmp/os-release.tmp
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${FEDORA_VERSION}\"|" /tmp/os-release.tmp
sed -i "s|^ID=.*|ID=bog|" /tmp/os-release.tmp
sed -i "s|^ID_LIKE=.*|ID_LIKE=\"fedora\"|" /tmp/os-release.tmp

# Add image-specific variable if not present
grep -q "^IMAGE_ID=" /tmp/os-release.tmp || \
    echo "IMAGE_ID=bog" >> /tmp/os-release.tmp
grep -q "^IMAGE_VERSION=" /tmp/os-release.tmp || \
    echo "IMAGE_VERSION=${FEDORA_VERSION}" >> /tmp/os-release.tmp

cp /tmp/os-release.tmp /usr/lib/os-release
echo "os-release configured: bog ${FEDORA_VERSION}"