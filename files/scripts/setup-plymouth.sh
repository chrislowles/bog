#!/usr/bin/env bash
set -oue pipefail

# Check for spinner.so at known locations (path changed from lib64 to lib in Fedora 40+)
SPINNER_SO=""
if [ -f /usr/lib/plymouth/spinner.so ]; then
    SPINNER_SO=/usr/lib/plymouth/spinner.so
elif [ -f /usr/lib64/plymouth/spinner.so ]; then
    SPINNER_SO=/usr/lib64/plymouth/spinner.so
fi

if [ -z "${SPINNER_SO}" ]; then
    echo "ERROR: spinner.so not found at /usr/lib/plymouth/ or /usr/lib64/plymouth/"
    echo "Contents of /usr/lib/plymouth/ (if it exists):"
    ls /usr/lib/plymouth/ 2>/dev/null || echo "  (directory does not exist)"
    exit 1
fi

echo "Found spinner plugin at: ${SPINNER_SO}"

if [ ! -f /usr/share/plymouth/themes/bog/bog.plymouth ]; then
    echo "ERROR: bog theme not found at /usr/share/plymouth/themes/bog/bog.plymouth"
    exit 1
fi

plymouth-set-default-theme bog
echo "Plymouth default theme set to: $(plymouth-set-default-theme)"