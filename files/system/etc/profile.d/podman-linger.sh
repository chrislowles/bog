#!/usr/bin/env bash
# Enable systemd linger for the current user on first login
# Required for rootless podman user services to start without active session

if [ "${UID}" -ge 1000 ] && [ -z "${PODMAN_LINGER_SET:-}" ]; then
    if ! loginctl show-user "${USER}" 2>/dev/null | grep -q "Linger=yes"; then
        loginctl enable-linger "${USER}"
    fi
    export PODMAN_LINGER_SET=1
fi