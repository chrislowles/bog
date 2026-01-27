# Containerfile - Builds your custom image

ARG BASE_IMAGE_URL=ghcr.io/ublue-os/base-main
# ARG FEDORA_VERSION=40

FROM ${BASE_IMAGE_URL}
# FROM ${BASE_IMAGE_URL}:${FEDORA_VERSION}

# Copy configuration files
COPY config /tmp/config

# Copy and execute installation scripts
COPY config/scripts/install-gnome.sh /tmp/install-gnome.sh
COPY config/scripts/setup-distrobox.sh /tmp/setup-distrobox.sh
COPY config/scripts/configure-flatpak.sh /tmp/configure-flatpak.sh
COPY config/scripts/cleanup.sh /tmp/cleanup.sh

# Make scripts executable and run them
RUN chmod +x /tmp/*.sh && \
    /tmp/install-gnome.sh && \
    /tmp/setup-distrobox.sh && \
    /tmp/configure-flatpak.sh && \
    /tmp/cleanup.sh

# Metadata
LABEL org.opencontainers.image.title="Bog"\
LABEL org.opencontainers.image.description="Custom immutable Linux with minimal GNOME"
LABEL io.artifacthub.package.readme-url="https://raw.githubusercontent.com/chrislowles/bog/main/README.md"