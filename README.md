# bog
A barebones (some may say _*bog*_ standard) immutable Linux distro using GNOME/GDM and flatpak/distrobox as a means for software management.

## Features
- **Minimal GNOME Desktop**: Lightweight GNOME installation with essential applications, additional desktop applications available on Flathub (pre-installed)
- **Immutable Base**: Built on Universal Blue's base-main for reliability and security
- **Multiple Variants**: AMD, NVIDIA (with pre-installed drivers), and VM-optimized builds
- **Flatpak Ready**: Flathub configured and available at first boot
- **Distrobox Support**: Container-based environments

## Variants
### bog-nvidia
- Pre-installed NVIDIA drivers (kernel module + addons)
- NVIDIA power management services enabled
- Optimized for NVIDIA GPUs
### bog-amd
- Mesa drivers (included in base image)
- Optimized for AMD GPUs
### bog-vm
- QEMU guest agent
- Open VM Tools
- SPICE VDAgent
- Optimized for virtualized workflows/VMs

## Installation

### Prerequisites
- A system capable of running rpm-ostree based distributions
- Internet connection for image download

### Rebasing from an existing rpm-ostree system

For NVIDIA systems:
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-nvidia:latest
```

For AMD systems:
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-amd:latest
```

For virtual machines:
```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/chrislowles/bog-vm:latest
```

After rebasing, reboot your system:
```bash
systemctl reboot
```

## Post-Installation

### Flatpak Applications

There are no pre-run configurations for flatpaks other than adding Flathub as a repository. You may install applications with:
```bash
flatpak install flathub org.mozilla.firefox
```

Searching your added flatpak repos:
```bash
flatpak search com.spotify.Client
```

Searching specific flatpak repos (Flathub):
```bash
flatpak search flathub com.spotify.Client
```

### Distrobox Setup

The below example creates an Arch Linux container with the yay AUR helper:
```bash
distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git" -- bash -c "git clone https://aur.archlinux.org/yay-bin.git;cd yay-bin;makepkg -si"
```

## Building Custom Images
The project uses GitHub Actions for automated builds. Images are built:
- On push to main branch
- On pull requests
- Weekly (Tuesday midnight)
- Manual workflow dispatch

### Local Development
To test builds locally:
```bash
podman build -f Containerfile.nvidia -t bog-nvidia:test .
```

## Software Management

### System Updates
```bash
rpm-ostree upgrade
systemctl reboot
```

### Using Flatpak (Recommended for GUI apps)
```bash
flatpak install flathub <app-id>
```

### Using Distrobox (Recommended for traditional linux system management)
```bash
distrobox enter arch
# Inside container:
yay -S <package-name>
# Or:
sudo pacman -S <package-name>
```

### Layering System Packages (NOT RECOMMENDED, PREFER DISTROBOX-BASED INSTALLATION AT MOST)
```bash
rpm-ostree install <package-name>
systemctl reboot
```

## License
Apache License 2.0 - See LICENSE file for details

## Note
This is a personal project and not intended for professional use. Use at your own risk.