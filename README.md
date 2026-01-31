# bog
A barebones (some may say _*bog*_ standard) immutable Linux distro. Built on Universal Blue (Fedora Atomic), it features a minimal GNOME desktop, pre-configured Flathub, and Distrobox for containerized linux environments.

## Purpose & Features
This project aims to provide a reliable, maintenance-free desktop base that separates the OS from applications.
- **Immutable Base**: Built on [Universal Blue](https://universal-blue.org/)'s `base-main` (Fedora Atomic) for atomic updates and reliability.
- **Minimal GNOME**: Includes only the essentials (Shell, Settings, Nautilus, Terminal, etc.) to keep the image lightweight.
- **Flatpak First**: Flathub is enabled by default for all GUI applications.
- **Distrobox Native**: `toolbox` has been removed and replaced with `distrobox`.
- **Hardware Optimized**: Specific images for AMD, NVIDIA, and Virtual Machines.

## Variants
**bog-amd**: The base image. Uses Mesa drivers; ideal for AMD Radeon or Intel graphics.
**bog-nvidia**: Includes pre-installed proprietary NVIDIA drivers (kernel modules + libs) and power management services enabled.
**bog-vm**: Optimized for virtualization. Includes QEMU Guest Agent, Open VM Tools, and SPICE VDAgent.

## Installation
### Method 1: ISO Installation (Recommended)
Weekly ISO builds are available in the [GitHub Releases](https://github.com/chrislowles/bog/releases).
1. Download the ISO matching your hardware (`bog-amd`, `bog-nvidia`, or `bog-vm`).
2. **Verify the checksum** (see below).
3. Flash to a USB drive (using [Rufus](https://rufus.ie/), [Etcher](https://etcher.balena.io/), or `dd`) or drag downloaded ISO into USB flashed with [https://www.ventoy.net/](Ventoy) multiboot.
4. Boot and follow the Fedora installer.

### Method 2: Rebase from Existing System
If you are already running a system that runs `rpm-ostree` (Silverblue, Kinoite, Bazzite), you can switch to `bog` without reinstalling, hell you might not even need to reinstall apps.
**For AMD/Intel:**
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-amd:latest
```

**For NVIDIA:**
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-nvidia:latest
```

**For Virtual Machines:**
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-vm:latest
```

*Reboot after the rebase completes.*

### Verifying ISO Checksums
It is highly recommended to verify the integrity of the ISO before installation. Download the matching `.CHECKSUM` file from the release page.

**Linux:**
```bash
sha256sum -c bog-nvidia-20240201.iso-CHECKSUM
```

*Expected output:* `bog-nvidia-20240201.iso: OK`

## Post-Installation
### Software Management
* **System Updates**: Though Bog updates automatically (atomic updates). You can force an update with:
```bash
rpm-ostree upgrade
```

* **GUI Applications**: Though Bog is a low effort distro it's encouraged to use the terminal to at least install your software:
```bash
flatpak install flathub org.mozilla.firefox
```

### Containerized Environments (Distrobox)
Distrobox is pre-installed and configured. You can create containers for whatever need you may have without layering packages on the host.
**Creating an example Distrobox (e.g., Arch Linux with `yay`):**
```bash
distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git" -- bash -c "git clone https://aur.archlinux.org/yay-bin.git;cd yay-bin;makepkg -si"
distrobox enter arch
```

## Building Locally
To build and test the images locally using Podman:
```bash
# Build the AMD base
podman build -f Containerfile -t bog-amd:test .

# Build the NVIDIA variant (requires the base to be built or pulled)
podman build -f Containerfile.nvidia --build-arg FROM_IMAGE=bog-amd:test -t bog-nvidia:test .
```

## Automation
This repository uses GitHub Actions to:
1. Build and push OCI images to GHCR (Triggered on push/schedule).
2. Build installation ISOs using the latest images (Triggered weekly).
3. Publish releases with ISO artifacts.

## License
Apache License 2.0 - See [LICENSE](https://github.com/chrislowles/bog/blob/main/LICENSE) file for details.

---

*Note: This is a personal project. Use at your own risk.*