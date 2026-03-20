#!/usr/bin/env bash

# Straightening out variables for AppImages so they are more reliable.

export HOME=/var/home/$USER
export APPIMAGE_EXTRACT_AND_RUN=1
export TMPDIR=~/.cache/appimage-tmp
export ELECTRON_OZONE_PLATFORM_HINT=auto
mkdir -p "$TMPDIR"