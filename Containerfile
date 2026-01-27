ARG BASE_IMAGE_URL=ghcr.io/ublue-os/base-main
ARG IMAGE_TAG=latest

FROM ${BASE_IMAGE_URL}:${IMAGE_TAG}

# Copy configuration files
COPY config /tmp/config

# Copy and execute installation scripts
COPY config/scripts/install-gnome.sh /tmp/install-gnome.sh
COPY config/scripts/setup-distrobox.sh /tmp/setup-distrobox.sh
COPY config/scripts/configure-flatpak.sh /tmp/configure-flatpak.sh
COPY config/scripts/cleanup.sh /tmp/cleanup.sh

# Run installation scripts
RUN /bin/bash /tmp/install-gnome.sh
RUN /bin/bash /tmp/setup-distrobox.sh
RUN /bin/bash /tmp/configure-flatpak.sh
RUN /bin/bash /tmp/cleanup.sh

# Metadata
LABEL org.opencontainers.image.title="Bog"
LABEL org.opencontainers.image.description="Custom immutable Linux with minimal GNOME"
LABEL io.artifacthub.package.readme-url="https://raw.githubusercontent.com/chrislowles/bog/main/README.md"