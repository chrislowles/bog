# Shell utilities
A set of shell functions are available in any terminal session:

| Function | What it does |
|---|---|
| `gtns` | Interactive system upgrade: runs `bootc upgrade` + `flatpak update`, with optional cleanup and reboot |
| `getmedia` | `yt-dlp` shorthand for downloading video (`-v`) or audio (`-a`) with metadata and thumbnails |
| `power` | Shorthand for reboot, shutdown, or suspend |
| `steam_shortcuts` | Lists or flushes Steam game `.desktop` shortcuts |

### Optional: Jackett
A rootless Podman container definition is included for Jackett (a torrent indexer proxy). Enable it as a user service when needed (this only works per user):
```bash
systemctl --user enable --now jackett
```