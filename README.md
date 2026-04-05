# bog (ublue/fedora atomic image)
A barebones (some may say bog standard) immutable Linux distro based on Universal Blue technologies using GNOME/GDM and flatpak/distrobox as its means for software management (with root-installed Steam)

## Installation

### Method 1: `sudo bootc switch`
One such method of switching to `bog` is by typing the below command into the terminal of an existing Fedora Atomic system:
```bash
sudo bootc switch ghcr.io/chrislowles/bog:latest
```

Reboot to complete the switch:
```bash
systemctl reboot
```

## Optional Features

### Jackett
For use if/when you want to install a Bittorrent client with Jackett plugin support, this is preferred when collecting public and private sources for torrenting as opposed to seperate search plugins for different services.
```bash
systemctl --user enable --now jackett
```

### Distrobox: A Traditional Linux Experience, Containerized
For use when you find software/a utility with only 1 sure-fire set of official Linux instructions, such is the habit of software packagers sometimes. Below are a few example lines to create/manage a distrobox.

#### Create Distrobox (Arch Linux w/ Basic Source-Building Utilities & `yay` AUR helper)
```bash
# create is the function needed to be called when creating a new container
# --pull requests the image in the command to be pulled regardless of whether or not it's been previously pulled
# -Y auto accepts all prompts for the container creation
# -n is the name of the container
# -i is the image to be called upon and used when generating the container, "archlinux:latest" is simply the latest 
# -ap is a variable set for additional packages needed for whatever needs to be installed for setup

distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git" -- distrobox enter arch
```

#### Suggested first-time activity: Download and build `yay` AUR helper to install AUR packages
```bash
# git is a version control system
# cd is a standard cmd for navigating directories
# makepkg -si is the standard cmd for building a package from the AUR with base-devel
# just copy the line below and run when in the distrobox, the semi-colons and slashes are just to make it a one-liner
git clone https://aur.archlinux.org/yay-bin.git; \ cd yay-bin; \ makepkg -si;
```

---

### Regarding Bluebuild:

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO
If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigcos/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:
```bash
cosign verify --key cosign.pub ghcr.io/chrislowles/bog
```