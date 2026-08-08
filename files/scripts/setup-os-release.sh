#!/usr/bin/env bash
set -euo pipefail

# TODO: restore old versioning in actual os-release variables, I'd just like the name in the bootloader screen to just read as: bog <fedora-base-version> (<shortform git version tag for image, idk how to source this here lol>)

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