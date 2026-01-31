ARG BASE_IMAGE_URL=ghcr.io/ublue-os/base-main
ARG IMAGE_TAG=latest

FROM ${BASE_IMAGE_URL}:${IMAGE_TAG}

# Install Desktop Components, Fonts, and Distrobox
RUN rpm-ostree install \
        NetworkManager-wifi NetworkManager-wwan NetworkManager-tui \
        gnome-shell gdm gnome-session gnome-settings-daemon gnome-keyring \
        xdg-desktop-portal-gnome xdg-user-dirs-gtk gnome-terminal \
        gnome-control-center gnome-system-monitor nautilus gnome-text-editor \
        gnome-disk-utility gnome-logs baobab dconf-editor \
        gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free \
        google-noto-sans-fonts google-noto-serif-fonts google-noto-emoji-fonts liberation-fonts \
        distrobox && \
    rpm-ostree override remove toolbox && \
    rpm-ostree cleanup -m

# Configure Distrobox
RUN mkdir -p /etc/distrobox && \
    cat > /etc/distrobox/distrobox.ini << 'EOF'
[General]
container_image_registry_credentials=""
container_manager="podman"
container_name_prefix="dev"
non_interactive="false"
skip_workdir="false"
verbose="false"

[container_manager_additional_flags]
create=""
enter=""
list=""
rm=""
stop=""
EOF

# Configure Flatpak
RUN flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    flatpak remote-modify --enable flathub

# Metadata
LABEL org.opencontainers.image.title="Bog"
LABEL org.opencontainers.image.description="Custom immutable Linux with minimal GNOME"
LABEL io.artifacthub.package.readme-url="https://raw.githubusercontent.com/chrislowles/bog/main/README.md"