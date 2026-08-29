# Distrobox (Distros in Distros)

Distrobox lets you run a full Linux distribution inside a container that integrates with your desktop, useful when software only has a reliable install path for a specific distro, or when you want access to a traditional package manager without breaking the immutable base.

## Example #1: Debian Sid
**Step 1 - Create the container:**
```bash
distrobox create --pull -Y -n debian -i docker.io/library/debian:unstable
```
| Flag | Meaning |
|---|---|
| `--pull` | Always pull a fresh copy of the image, even if it's been pulled before |
| `-Y` | Auto-accept all prompts during container setup |
| `-n debian` | Name the container `debian` |
| `-i debian:unstable` | Use the official Debian Sid (Unstable) cloud image |
**Step 2: - Enter the container and install a .deb file**
```bash
distrobox enter debian
# cd <where-file-is> OR ignore if already in directory/folder where .deb file is.
sudo apt install ./<.deb-file-name>.deb
```
| Part | Meaning |
|---|---|
| `distrobox enter arch` | Enter the container named `debian` |
| `cd <where-file-is>` | Navigate into the directory where the .deb file is |
| `sudo apt install ./<.deb-file-name>.deb` | Install the package with apt. |

Once `yay` is installed, packages from the Arch User Repository can be installed with `yay -S <package>` from inside the container and again exported to the host desktop with Distroshelf, available in the main menu.

## Example #2: Arch Linux with yay (AUR helper)
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
| `-ap "base-devel git"` | Install these additional packages during initial setup |
**Step 2 - Enter the container and install yay:**
```bash
distrobox enter arch
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```
| Part | Meaning |
|---|---|
| `distrobox enter arch` | Enter the container named `arch` |
| `git clone ...` | Download the yay build files from the AUR (requires `git`) |
| `cd yay-bin` | Navigate into the cloned directory |
| `makepkg -si` | Build and install the package (requires `base-devel`) |

Once `yay` is installed, packages from the Arch User Repository can be installed with `yay -S <package>` from inside the container and again exported to the host desktop with Distroshelf, available in the main menu.