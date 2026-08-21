#!/usr/bin/env bash
set -euo pipefail

source /usr/lib/os-release
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${OSTREE_VERSION}\"|" /usr/lib/os-release

echo "os-release PRETTY_NAME stamped: bog ${OSTREE_VERSION}"