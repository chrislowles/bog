#!/usr/bin/env bash
set -euo pipefail

# Bump these at the same time (hash is in the releases .sha256 asset, click copy on release page).
MILLENNIUM_VERSION="3.6.3"
MILLENNIUM_SHA256="9d9a5f8448cf92f4634d6ea49b5263409157cccf5b68a8ff10e962c8d7e52c28"

TARBALL="millennium-v${MILLENNIUM_VERSION}-linux-x86_64.tar.gz"
URL="https://github.com/SteamClientHomebrew/Millennium/releases/download/v${MILLENNIUM_VERSION}/${TARBALL}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

curl -fsSL --retry 3 -o "$work/$TARBALL" "$URL"
echo "${MILLENNIUM_SHA256}  $work/$TARBALL" | sha256sum -c -
tar -xzf "$work/$TARBALL" -C "$work"

[ -d "$work/usr/lib/millennium" ] || { echo "unexpected tarball layout:"; find "$work" -maxdepth 3; exit 1; }

install -d /usr/lib/millennium
cp -a "$work/usr/lib/millennium/." /usr/lib/millennium/

# Fail the build (not the user's Steam) if upstream renames a library.
for f in libmillennium_bootstrap_x64.so libmillennium_hhx64.so; do
  [ -e "/usr/lib/millennium/$f" ] || { echo "missing $f"; ls -l /usr/lib/millennium; exit 1; }
done

echo "millennium.sh: Locked in Millennium ${MILLENNIUM_VERSION} pre-install oneshot"