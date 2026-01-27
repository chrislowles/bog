#!/usr/bin/bash
set -euo pipefail

echo "Setting up distrobox for containerized software management..."

# Install distrobox
rpm-ostree install distrobox

# Remove toolbx if present (optional)
rpm-ostree override remove toolbox || true

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