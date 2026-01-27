#!/usr/bin/bash

echo "Setting up distrobox for containerized software management..."

rpm-ostree install distrobox

set +e
rpm-ostree override remove toolbox 2>/dev/null
set -e

mkdir -p /etc/distrobox

cat > /etc/distrobox/distrobox.ini << 'EOF'
[General]
container_image_registry_credentials=""
container_manager="podman"
container_name_prefix="dev"
non_interactive="false"
skip_workdir="false"
verbose="false"

[container_manager_additional_flags]
create=""
enter=""
list=""
rm=""
stop=""
EOF

echo "Distrobox setup complete."