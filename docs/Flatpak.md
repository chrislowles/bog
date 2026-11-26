Below are various common scenarios that relate to flatpak, the distribution-agnostic app format used to install software in bog.

## Filesystem Access
Apps using the flatpak format are sandboxed by default - most only see their own data directory plus a few standard folders like the Downloads, Videos or Music folder. That's usually enough until an app needs to read something outside that sandbox, like opening a photo from a secondary drive in Firefox installed from Flathub.

### Granting access with Flatseal
Flatseal is installed by default (`com.github.tchx84.Flatseal`).
1. Open Flatseal, pick the app (e.g. Firefox).
2. Under **Filesystem**, either:
  * Toggle one of the broad presets (`All user files`, `All system files`) - simplest, but gives up most of the sandboxing benefit.
  * Or click **Other files**, and add the specific path you need, e.g. `/var/mnt/NVME1/Homework` or `/run/media/<user>/<label>`.
3. Relaunch the app for the change to take effect, if problems turn up reboot the computer.

# Notable third-party flatpak remotes
Beyond Flathub, there are other remotes hosted for various purposes such as ones listed below:
* Interim hosting while Flathub submissions are processed like "yellow keycard flatpaks"
* Single purpose remotes meant to host single pieces of software like GeForce NOW
* All-out alternative hubs to Flathub like FlatPark
* For software mainly intended to be used in their operating system such as Fedora Linux's filtered version of Flathub or bog's very own **bog-flatpak**

If you want to install software from some of the above mentioned remotes, copy the corresponding commands below and run them in the terminal.

[FlatPark](https://flatpark.org/)
```bash
flatpak remote-add flatpark https://dl.flatpark.org/flatpark.flatpakrepo
```

["yellow keycard flatpaks"](https://flatpak.yellowkeycard.net/)
```bash
flatpak remote-add --user ykc https://flatpak.yellowkeycard.net/ykc.flatpakrepo
```

[GeForce NOW Official Flatpak Remote](https://www.nvidia.com/en-us/geforce-now/download/)
```bash
flatpak remote-add --user gfn https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
```