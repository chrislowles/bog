#!/usr/bin/env bash
set -oue pipefail
dnf install -y --setopt=protected_multilib=false libsoup3 libsoup3.i686