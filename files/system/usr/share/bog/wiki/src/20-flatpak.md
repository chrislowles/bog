# Flatpak Filesystem Access
Apps using the flatpak format are sandboxed by default - most only see their own data directory plus a few standard folders like the Downloads, Videos or Music folder. That's usually enough until an app needs to read something outside that sandbox, like opening a photo from a secondary drive in Firefox installed from Flathub.

## Granting access with Flatseal
Flatseal is installed by default (`com.github.tchx84.Flatseal`).
1. Open Flatseal, pick the app (e.g. Firefox).
2. Under **Filesystem**, either:
  * Toggle one of the broad presets (`All user files`, `All system files`) - simplest, but gives up most of the sandboxing benefit.
  * Or click **Other files**, and add the specific path you need, e.g. `/var/mnt/NVME1/Homework` or `/run/media/<user>/<label>`.
3. Relaunch the app for the change to take effect, if problems turn up reboot the computer.

## A gentler alternative: the file portal
Before reaching for Flatseal, try the app's normal **Open File** dialog first. GNOME's file portal (`xdg-desktop-portal-gnome`) lets sandboxed apps browse and open files you pick interactively, without any standing filesystem grant - this covers a lot of "I just need to open one file" cases without touching Flatseal at all, the downside (again considering flatpak Firefox as the example) is the portal only creates a temporary link to the single file and rebooting with the file open in the tab returns an 404.

Flatseal is for the recurring case: an app that needs to read/write a specific folder on every launch, not just once.

## Automount gotchas
Removable and secondary drives that aren't in `/etc/fstab` get mounted by `gvfs`/`udisks` under `/run/media/<user>/<label>` - and that path changes if the drive's label changes. If a Flatpak app's Filesystem grant stops working after you relabeled or reformatted a drive, this is usually why: the old path in Flatseal no longer matches.

Two ways around it:
* Give the drive a fixed mount point via **Disks → Edit Mount Options** (see [Storage & Drives](storage.html)) instead of relying on automount, then point Flatseal at that fixed path.
* Or re-check/re-add the Flatseal grant after any reformat/relabel.