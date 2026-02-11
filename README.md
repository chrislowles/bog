# bog (ublue/fedora atomic image)
A standard minimal GNOME/GDM system that uses flatpak/distrobox for daily operations (also pre-installed Steam)

We plan on using this to build a modern NVIDIA build made soon so stay tuned :)

## Installation

### Method 1: `sudo bootc switch`
One such method of switching to `bog` is by using the `sudo bootc switch ghcr.io/chrislowles/bog:latest`

### Method 2: `rpm-ostree rebase`
Another method is to use rpm-ostree to rebase an existing rpm-ostree distro (Bazzite, Bluefin, Silverblue), to rebase to the latest build of `bog`:

First rebase to the unsigned image, to get the proper signing keys and policies installed:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/blue-build/template:latest
```

Reboot to complete the rebase:
```bash
systemctl reboot
```

Then rebase to the signed image, like so:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/blue-build/template:latest
```

Reboot again to complete the installation:
```bash
systemctl reboot
```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO
If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification
These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:
```bash
cosign verify --key cosign.pub ghcr.io/chrislowles/bog
```