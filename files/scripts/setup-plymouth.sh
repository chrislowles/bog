#!/usr/bin/env bash
set -oue pipefail

# Install the theme and set it as default
plymouth-set-default-theme -R bog || true