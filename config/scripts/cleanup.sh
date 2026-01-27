#!/usr/bin/bash

echo "Cleaning up build artifacts..."

# Remove temporary files
rm -rf /tmp/config
rm -f /tmp/*.sh

# Clean package manager cache
rpm-ostree cleanup -m

echo "Cleanup complete."