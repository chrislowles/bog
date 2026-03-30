#!/usr/bin/env bash
set -euo pipefail

source /usr/lib/os-release
FEDORA_VERSION="${VERSION_ID}"
BUILD_DATE=$(date +%Y%m%d)
FULL_VERSION="${FEDORA_VERSION}.${BUILD_DATE}"

cp /usr/lib/os-release /tmp/os-release.tmp

sed -i "s|^NAME=.*|NAME=\"bog\"|" /tmp/os-release.tmp
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${FULL_VERSION}\"|" /tmp/os-release.tmp
sed -i "s|^VERSION_ID=.*|VERSION_ID=${FEDORA_VERSION}|" /tmp/os-release.tmp
sed -i "s|^ID=.*|ID=bog|" /tmp/os-release.tmp
sed -i "s|^ID_LIKE=.*|ID_LIKE=\"fedora\"|" /tmp/os-release.tmp

# Set the VERSION field (distinct from VERSION_ID) for the full readable string
grep -q "^VERSION=" /tmp/os-release.tmp && \
    sed -i "s|^VERSION=.*|VERSION=\"${FULL_VERSION}\"|" /tmp/os-release.tmp || \
    echo "VERSION=\"${FULL_VERSION}\"" >> /tmp/os-release.tmp

grep -q "^IMAGE_ID=" /tmp/os-release.tmp || echo "IMAGE_ID=bog" >> /tmp/os-release.tmp
grep -q "^IMAGE_VERSION=" /tmp/os-release.tmp || echo "IMAGE_VERSION=${FULL_VERSION}" >> /tmp/os-release.tmp
grep -q "^LOGO=" /tmp/os-release.tmp || echo "LOGO=bog-logo" >> /tmp/os-release.tmp

cp /tmp/os-release.tmp /usr/lib/os-release
echo "os-release configured: bog ${FULL_VERSION}"