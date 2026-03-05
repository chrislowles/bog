#!/usr/bin/env bash
set -oue pipefail

echo "Building Bazaar from source with custom configurations..."

BAZAAR_VERSION="v0.7.10"

echo "Cloning Bazaar ${BAZAAR_VERSION}..."
cd /tmp
git clone \
    --depth 1 \
    --branch ${BAZAAR_VERSION} \
    https://github.com/kolunmi/bazaar.git
cd bazaar

echo "Snapshotting pre-existing packages..."
rpm -qa --queryformat '%{NAME}\n' | sort > /tmp/before-build-deps.txt

echo "Installing build dependencies from spec..."
dnf builddep -y /tmp/bazaar/bazaar.spec

echo "Building Bazaar with custom configuration..."
meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dhardcoded_main_config_path=/etc/bazaar/main.yaml

ninja -C build

echo "Installing Bazaar..."
ninja -C build install

echo "Setting proper permissions for configuration files..."
chmod 644 /etc/bazaar/*.yaml || true
chmod 755 /etc/bazaar || true

echo "Setting proper permissions for service files..."
chmod 644 /usr/lib/systemd/user/io.github.kolunmi.Bazaar.service || true
chmod 644 /usr/share/dbus-1/services/io.github.kolunmi.Bazaar.service || true

echo "Verifying executable..."
if [ -f /usr/bin/bazaar ]; then
    echo "Bazaar executable installed at /usr/bin/bazaar"
    chmod 755 /usr/bin/bazaar
    echo "Set executable permissions"
else
    echo "WARNING: Bazaar executable not found!"
fi

echo "Verifying desktop file..."
if [ -f /usr/share/applications/io.github.kolunmi.Bazaar.desktop ]; then
    echo "Desktop file installed"
else
    echo "WARNING: Desktop file not found!"
fi

echo "Compiling gschema..."
glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "Removing build-only dependencies..."
rpm -qa --queryformat '%{NAME}\n' | sort > /tmp/after-build-deps.txt
ADDED=$(comm -13 /tmp/before-build-deps.txt /tmp/after-build-deps.txt | tr '\n' ' ')
if [ -n "$ADDED" ]; then
    dnf remove -y $ADDED
else
    echo "No new packages to remove."
fi

echo "Explicitly verifying critical runtime libraries are still present..."
if ldconfig -p | grep -q "libglycin-gtk4-2.so.0"; then
    echo "libglycin-gtk4-2.so.0 is present"
else
    echo "WARNING: libglycin-gtk4-2.so.0 not found!"
fi

dnf clean all

echo ""
echo "============================================"
echo "Bazaar custom build complete!"
echo "============================================"

echo "Configuration:"
echo "  - Main config: /etc/bazaar/main.yaml"
echo "  - Blocklist: /etc/bazaar/blocklist.yaml"
echo "  - Curated content: /etc/bazaar/curated.yaml"

echo ""

echo "Service files:"
echo "  - User service: /usr/lib/systemd/user/io.github.kolunmi.Bazaar.service"
echo "  - D-Bus service: /usr/share/dbus-1/services/io.github.kolunmi.Bazaar.service"

echo ""

echo "To modify configuration:"
echo "Edit files in: files/system/etc/bazaar/"

echo ""

echo "Note: Runtime libraries preserved during cleanup."
echo "============================================"