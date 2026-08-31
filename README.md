# bog

A personal, *slightly* opinionated [Fedora Atomic](https://fedoraproject.org/atomic-desktops/) image built with [BlueBuild](https://blue-build.org/) and the [Universal Blue](https://universal-blue.org/) toolchain. Immutable base, Flatpak-first, with Steam baked in.

A [wiki](https://github.com/chrislowles/bog/wiki) is available for certain aspects of running the distro.

## What's included
- Near-vanilla **GNOME** desktop with GDM
- **Bazaar** as the primary app store
- **flatpak** via [**Flathub**](https://flathub.org/): the primary space for applications installed using the distro-agnostic flatpak format
- [**Distrobox**](https://distrobox.it/) for containerised access to traditional Linux software management
- [**Steam**](https://store.steampowered.com/) as part of the base/system level for ease-of-use when gaming
- Optional SystemD services for common application extension platforms and utilities (Jackett for qBittorrent)
- AppIndicator, Caffeine, and Quick Sound Switcher extensions available and enabled out of the box

## Installation
From any existing Fedora Atomic system:
```bash
sudo bootc switch ghcr.io/chrislowles/bog:latest
systemctl reboot
```
...and for any running NVIDIA hardware:
```bash
sudo bootc switch ghcr.io/chrislowles/bog-nvidia:latest
systemctl reboot
```
ISOs are now also available for burning to a USB on the [releases](https://github.com/chrislowles/bog/releases) tab.

## Verification
Images are signed with [Sigstore](https://www.sigstore.dev/) cosign. Verify with:
```bash
cosign verify --key cosign.pub ghcr.io/chrislowles/bog
```