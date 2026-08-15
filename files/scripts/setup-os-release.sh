#!/usr/bin/env bash
set -euo pipefail

source /usr/lib/os-release
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"bog ${VERSION_ID}\"|" /usr/lib/os-release

echo "os-release PRETTY_NAME stamped: bog ${VERSION_ID}"