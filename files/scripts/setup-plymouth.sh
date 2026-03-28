#!/usr/bin/env bash
set -oue pipefail

# Verify theme and plugin exist before setting
if [ ! -f /usr/lib64/plymouth/spinner.so ]; then
    echo "ERROR: spinner.so not found - is plymouth-plugin-spinner installed?"
    exit 1
fi

if [ ! -f /usr/share/plymouth/themes/bog/bog.plymouth ]; then
    echo "ERROR: bog theme not found"
    exit 1
fi

# Set default theme - skip initramfs rebuild (-R) as it reliably fails
# in OCI build containers. The initramfs is rebuilt automatically on
# first boot by rpm-ostree/bootc.
plymouth-set-default-theme bog

echo "Plymouth default theme set to: $(plymouth-set-default-theme)"