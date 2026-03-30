#!/usr/bin/env bash
set -oue pipefail

if [ ! -f /usr/share/plymouth/themes/bog/bog.plymouth ]; then
    echo "ERROR: bog theme not found"
    exit 1
fi

plymouth-set-default-theme bog