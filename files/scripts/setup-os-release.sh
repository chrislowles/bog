#!/usr/bin/env bash
set -euo pipefail

source /usr/lib/os-release
FEDORA_VERSION="${VERSION_ID}"
BUILD_DATE=$(date +%Y%m%d)
FULL_VERSION="${FEDORA_VERSION}.${BUILD_DATE}"

cp /usr/lib/os-release /tmp/os-release.tmp

sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${FULL_VERSION}\"|" /tmp/os-release.tmp

grep -q "^VERSION=" /tmp/os-release.tmp && \
    sed -i "s|^VERSION=.*|VERSION=\"${FULL_VERSION}\"|" /tmp/os-release.tmp || \
    echo "VERSION=\"${FULL_VERSION}\"" >> /tmp/os-release.tmp

grep -q "^IMAGE_VERSION=" /tmp/os-release.tmp || echo "IMAGE_VERSION=${FULL_VERSION}" >> /tmp/os-release.tmp

cp /tmp/os-release.tmp /usr/lib/os-release

echo "os-release version stamped: bog ${FULL_VERSION}"