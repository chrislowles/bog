#!/usr/bin/env bash
set -oue pipefail

# Force libsoup3 x86_64 to 3.6.6 directly from Koji to match i686 in updates,
# resolving the multilib version mismatch that blocks the main dnf transaction.
dnf install -y \
    https://kojipkgs.fedoraproject.org/packages/libsoup3/3.6.6/1.fc43/x86_64/libsoup3-3.6.6-1.fc43.x86_64.rpm \
    https://kojipkgs.fedoraproject.org/packages/libsoup3/3.6.6/1.fc43/i686/libsoup3-3.6.6-1.fc43.i686.rpm