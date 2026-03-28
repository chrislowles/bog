#!/usr/bin/env bash
set -oue pipefail

# Find spinner.so regardless of lib/lib64 location (Fedora moved these in F40+)
SPINNER_SO=$(find /usr/lib/plymouth /usr/lib64/plymouth -name "spinner.so" 2>/dev/null | head -1)

if [ -z "${SPINNER_SO}" ]; then
    echo "ERROR: spinner.so not found in Plymouth plugin directories"
    echo "Available Plymouth plugins:"
    find /usr/lib/plymouth /usr/lib64/plymouth -name "*.so" 2>/dev/null || echo "  (none found)"
    exit 1
fi

echo "Found spinner plugin at: ${SPINNER_SO}"

if [ ! -f /usr/share/plymouth/themes/bog/bog.plymouth ]; then
    echo "ERROR: bog theme not found at /usr/share/plymouth/themes/bog/bog.plymouth"
    exit 1
fi

plymouth-set-default-theme bog
echo "Plymouth default theme set to: $(plymouth-set-default-theme)"