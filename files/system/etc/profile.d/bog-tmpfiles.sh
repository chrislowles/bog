#!/usr/bin/env bash

# Ensure bog's user-scope tmpfiles (seeded config/service files) are reconciled on every login, not just at account creation. Covers accounts that existed before a given bog feature shipped.

if [ "${UID}" -ge 1000 ] && [ -z "${BOG_TMPFILES_SET:-}" ]; then
    systemctl --user enable --now systemd-tmpfiles-setup.service &>/dev/null
    systemd-tmpfiles --user --create &>/dev/null
    export BOG_TMPFILES_SET=1
fi