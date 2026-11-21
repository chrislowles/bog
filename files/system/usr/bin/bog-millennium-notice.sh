#!/usr/bin/env bash

# One-shot first-login notice: Millennium hooks into Steam only after Steam has run once.
marker="${XDG_STATE_HOME:-$HOME/.local/state}/bog/millennium-notice"
mkdir -p "${marker%/*}"

[ -e "$marker" ] && exit 0

# Steam already bootstrapped (e.g. existing account): nothing to tell them.
[ -e "$HOME/.local/share/Steam/steam.sh" ] && { touch "$marker"; exit 0; }

choice=$(notify-send -a bog -i steam -A open="Open Steam" \
    "Millennium Notice" \
    "Open Steam at least once and let it bootstrap so Millennium can hook in; log out and back in to finish.") || exit 0

touch "$marker"   # only after a successful send, so failures retry next login
[ "$choice" = open ] && exec steam