# bog

A personal, *slightly* opinionated [Fedora Atomic](https://fedoraproject.org/atomic-desktops/) image built with [BlueBuild](https://blue-build.org/) and the [Universal Blue](https://universal-blue.org/) toolchain. Immutable base, Flatpak-first, with Steam baked in.

## What's included

### Desktop
- **GNOME** with GDM, pre-configured via dconf
- **Bazaar** as the primary app store, with a curated catalogue spanning gaming, emulation, browsers, productivity, media, and more
- AppIndicator, Caffeine, and Quick Sound Switcher extensions enabled out of the box
- Inter and Comic Neue fonts installed system-wide
- Custom keybinds: `Super+T` (terminal), `Super+.` (GNOME Characters), `Super+U` (system upgrade launcher)

### Software management
- **Flatpak** via Flathub - the primary way to install apps
- **Distrobox** for containerised access to traditional package managers (see below)
- **Podman** configured for rootless operation, with linger enabled on first login
- **Steam** installed at the system level (not as a Flatpak)

### Shell utilities
A set of shell functions are available in any terminal session:

| Function | What it does |
|---|---|
| `gtns` | Interactive system upgrade: runs `bootc upgrade` + `flatpak update`, with optional cleanup and reboot |
| `getmedia` | `yt-dlp` shorthand for downloading video (`-v`) or audio (`-a`) with metadata and thumbnails |
| `setdns` | Configures DNS for the active NetworkManager connection (NextDNS supported) |
| `power` | Shorthand for reboot, shutdown, or suspend |
| `steam_shortcuts` | Lists or flushes Steam game `.desktop` shortcuts |
| `restore_app_guts` | Restores pre-written Flatpak configs and permission overrides for a given app |

### Optional: Jackett
A rootless Podman container definition is included for Jackett (a torrent indexer proxy). Enable it as a user service when needed:
```bash
systemctl --user enable --now jackett
```

## Distrobox: a traditional Linux experience, containerised

Distrobox lets you run a full Linux distribution inside a container that integrates with your desktop — useful when software only has a reliable install path for a specific distro, or when you want access to a traditional package manager without breaking the immutable base.

### Example: Arch Linux with yay (AUR helper)

**Step 1 - Create the container:**
```bash
distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git"
```

| Flag | Meaning |
|---|---|
| `--pull` | Always pull a fresh copy of the image, even if it's been pulled before |
| `-Y` | Auto-accept all prompts during container setup |
| `-n arch` | Name the container `arch` |
| `-i archlinux:latest` | Use the official Arch Linux cloud image |
| `-ap "base-devel git"` | Install these packages during initial setup |

**Step 2 - Enter the container and install yay:**
```bash
distrobox enter arch -- bash -c "git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si"
```

| Part | Meaning |
|---|---|
| `distrobox enter arch` | Enter the container named `arch` |
| `--` | Everything after this is run inside the container rather than on the host |
| `bash -c "..."` | Run the quoted string as a shell command |
| `git clone ...` | Download the yay build files from the AUR |
| `cd yay-bin` | Navigate into the cloned directory |
| `makepkg -si` | Build and install the package (requires `base-devel`) |

Once `yay` is installed, subsequent AUR packages can be installed with `yay -S <package>` from inside the container.

## Installation

From any existing Fedora Atomic system:

```bash
sudo bootc switch ghcr.io/chrislowles/bog:latest
systemctl reboot
```

For NVIDIA hardware:

```bash
sudo bootc switch ghcr.io/chrislowles/bog-nvidia:latest
systemctl reboot
```

## Verification

Images are signed with [Sigstore](https://www.sigstore.dev/) cosign. Verify with:

```bash
cosign verify --key cosign.pub ghcr.io/chrislowles/bog
```