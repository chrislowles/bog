## "Get The New S***"
`gtns` is the one-stop update command, under the hood it runs a standard base system update using `bootc upgrade` and a standard flatpak app library update using `flatpak update`.

## Bazaar
Separate from `gtns`, Bazaar is where you'll install apps and through it, be offered ways to both update and clear leftover cache of any uninstalled apps, the primary source for the software catalogue is derived from [Flathub](https://flathub.org) and soon the custom minimally hosted *bog-flatpak*, a minimal blocklist is embedded in the installation of Bazaar to avoid duplicate installations of base desktop applications as some programs are available as flatpaks on Flathub.

## Cleaning up leftover data

### **Unused Flatpak runtimes/apps**
`gtns` offers this as a prompt under "Uninstall unused Flatpak packages after update?", when prompted press `y` then enter or run `flatpak uninstall --unused` manually any time.

### **Distrobox containers** you no longer use:
```bash
distrobox list 		# lists active/created Distrobox containers
distrobox rm <name> # removes the container, you may be prompted to confirm
```

## If an update breaks something
bog uses the Universal Blue toolchain which powers distros like Bazzite, all of that is to say that updates keep the previous base system state around if something breaks in the desktop. If you run into something, roll back with:
```bash
sudo bootc rollback
systemctl reboot
```

This reverts the base image only, Flatpak app updates are isolated and usually aren't affected by a rollback, so if a Flatpak app itself is the problem, downgrade or reinstall it separately via Flatseal/Bazaar/Warehouse rather than rolling back the whole system.