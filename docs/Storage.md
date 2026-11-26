Below are various and common scenarios that relate to storage.

## Scenario #1: Adding a secondary drive for Steam
The list below involves the full process (w/ the maintainers preferences) so if you think you've already done the things up to a certain point skip that item, if not the below checklist should cover everything.
1. Open **Disks**, select the drive you wish to use for installing games on
2. Click on the 3-dot button next to the three-button navigation buttons (minimize, maximize, close) that reads "Drive Options" in the tooltip
3. A window will have come up that has two options for formatting your disk, the default "Quick" erase option titled "Don't overwrite existing data (Quick)" and the "Partitioning" option titled "Compatible with modern systems and hard disks > 2TB (GPT)" are standard and should only be changed when using legacy hardware like older hard-drives, select "Format" below.
4. Still in **Disks**, click the gear icon on the new partition > **Edit Mount Options**, and:
   * Disable "User Session Defaults".
   * Enable "Mount at system startup" if it hasn't been already, this mounts the volume/drive to your system at boot.
   * Enable "Show in user interface" if it hasn't been already, this lets you see your volume/drive in the file manager
   * Make sure "Require additional authorization to mount" is disabled to avoid mounting issues with Steam.
   * For peace of mind, if the fields "Display Name", "Icon Name" and "Symbolic Icon Name" contain any value, re-enable the previous option and empty it, re-enable and proceed.
   * Ensure the value set above "Mount Point" equals `nosuid,nodev,nofail,x-gvfs-show`, this may already be set by interacting with the previous items touched upon here.
5. Set a mount point, e.g. `/mnt/NVME1`.
6. In the drop down entitled as "Identify As" select the option that reads as `/dev/disk/by-uuid/` at the beginning and a randomly generated identifier afterwards.
7. Ensure the value written into the input at "Filesystem Type" is `auto`
8. Click "OK" to apply, then reboot (you can mount from here by clicking the play button in the bottom left corner of the volume but it's preferred you reboot for everything to settle and not be confused).
9. Open Steam > **Settings > Storage** > add the new volume/drive as a Steam Library Folder.
10. New installs can now target that library from the install dialog, or move existing games to it from **Properties > Local Files > Move Install Folder**.

## Verifying that a drive actually mounted (during current session)
```bash
lsblk -f
findmnt /var/mnt/games
```

## Scenario #2: Creating and adding a recursively scanned directory to PCSX2
Again, same as with Scenario #1, the list below involves the full process (w/ the maintainers preferences) so if you think you've already done the things up to a certain point skip that item, if not the below checklist should cover everything.
The list is presuming you have a collection of PS2 games located under `/var/mnt/NVME1/Emulation/PS2/`
1. After installing PCSX2 in Bazaar or through the `flatpak` CLI, open Flatseal and select the app (e.g. PCSX2).
3. Under **Filesystem** and in the **Other files** subsection, add the path you need, e.g. `/var/mnt/NVME1/Emulation/PS2`.
4. Relaunch the app for the path to become available and change to take effect, if problems turn up reboot the computer.


If it's not there after a reboot, re-check the Disks mount options, `nofail` masking a real mount failure is the most common cause but isn't always the culprit.