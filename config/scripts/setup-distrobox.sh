#!/usr/bin/bash

echo "Setting up distrobox for containerized software management..."

# Install distrobox
rpm-ostree install distrobox

# Remove toolbx if present (optional) - don't fail if it doesn't exist
set +e
rpm-ostree override remove toolbox
set -e

# Create distrobox configuration directory
mkdir -p /etc/distrobox

# Create default distrobox configuration
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