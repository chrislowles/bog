# bog (ublue/fedora atomic image)
A standard minimal GNOME/GDM system that uses flatpak/distrobox for daily operations (also root-installed Steam)

I plan on using this to build an NVIDIA image soon so stay tuned :)

## Installation

### Method 1: `sudo bootc switch`
One such method of switching to `bog` is by typing the below command into the terminal of your existing Fedora Atomic system:
```bash
sudo bootc switch ghcr.io/chrislowles/bog:latest
```

Reboot to complete the switch:
```bash
systemctl reboot
```

## First-run Recommendation: Pull/Enable Jackett
Jackett comes pre-installed with bog, for use if/when you want to install a Bittorrent client with Jackett plugin support, this is preferred when collecting public and private sources for torrenting.
```bash
systemctl --user enable --now jackett
```

--

### Regarding Bluebuild:

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO
If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:
```bash
cosign verify --key cosign.pub ghcr.io/chrislowles/bog
```