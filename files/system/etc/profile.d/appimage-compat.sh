#!/usr/bin/env bash
export HOME=/var/home/$USER
export APPIMAGE_EXTRACT_AND_RUN=1
export TMPDIR=~/.cache/appimage-tmp
mkdir -p "$TMPDIR"