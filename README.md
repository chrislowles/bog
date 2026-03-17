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

### SearXNG (Local Instance)
This software is often used as a publically accessible alternative to commercial search engines like Google or Bing. You can enable, configure and local use of SearXNG in your browser of choice by running this command, [INCOMPLETE]. Defer to your browser of choices documenation to add and set search engines as your default. The resulting URL pattern needed to access it will be `https://localhost:8888/search?q=%s`
```bash
systemctl --user enable --now searxng
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