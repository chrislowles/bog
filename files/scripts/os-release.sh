#!/usr/bin/env bash
set -euo pipefail

source /usr/lib/os-release

sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${OSTREE_VERSION}\"|" /usr/lib/os-release

echo "os-release.sh: PRETTY_NAME now reads as \"bog ${OSTREE_VERSION}\""