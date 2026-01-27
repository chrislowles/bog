#!/usr/bin/bash

echo "Cleaning up build artifacts..."

rm -rf /tmp/config
rm -f /tmp/*.sh

rpm-ostree cleanup -m

echo "Cleanup complete."