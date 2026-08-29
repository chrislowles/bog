# Keeping bog Tidy

## "Get The New S***"
`gtns` is the one-stop update command, under the hood it runs a standard base system update using `bootc upgrade` and a standard app library update using `flatpak update`, with prompts for system cleanup and reboot. It's also bound to `Super+U` and has its own menu launcher, though you have these options, it's preferred you open the terminal with `Super+T` and type in the following:
```bash
gtns
```

## Bazaar
Seperate from `gtns`, Bazaar is where you'll install apps and through it, will show ways to both update and clear leftover cache of any uninstalled apps, the primary source for the software catalogue is derived from [Flathub](https://flathub.org)

## Cleaning up leftover data
* **Unused Flatpak runtimes/apps**: `gtns` offers this as a prompt (`flatpak uninstall --unused`), or run it manually any time.
* **Distrobox containers** you no longer use:
```bash
distrobox list
distrobox rm <name>
```

## If an update breaks something
bog uses the Universal Blue toolchain which powers distros like Bazzite and is based on Fedora Atomic, all that is to say that updates keep the previous deployment around if something in the base breaks. If you run into something, roll back with:
```bash
sudo bootc rollback
systemctl reboot
```
This reverts the base image only, Flatpak app updates aren't affected by a rollback, so if a Flatpak app itself is the problem, downgrade or reinstall it separately via Flatseal/Bazaar rather than rolling back the whole system.