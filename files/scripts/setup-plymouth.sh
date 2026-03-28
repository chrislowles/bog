#!/usr/bin/env bash
set -oue pipefail

if [ ! -f /usr/share/plymouth/themes/bog/bog.plymouth ]; then
    echo "ERROR: bog theme not found at /usr/share/plymouth/themes/bog/bog.plymouth"
    exit 1
fi

# Write the Plymouth config directly rather than using plymouth-set-default-theme,
# which requires spinner.so to be present in the build container.
# The plugin is only needed at boot time, not during the image build.
mkdir -p /etc/plymouth
cat > /etc/plymouth/plymouthd.conf << 'EOF'
[Daemon]
Theme=bog
ShowDelay=5
EOF

echo "Plymouth config written. Default theme set to: bog"
cat /etc/plymouth/plymouthd.conf