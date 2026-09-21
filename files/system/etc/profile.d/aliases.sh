#!/usr/bin/env bash

# power [--reboot | --shutdown | --suspend]
power() {
    case "${1:-}" in
        --reboot)   systemctl reboot ;;
        --shutdown) systemctl poweroff ;;
        --suspend)  systemctl suspend ;;
        *)  echo "Usage: power [--reboot | --shutdown | --suspend]" ;;
    esac
}

# bogreset
# Reinstalls bog from scratch using the currently-booted image via system-reinstall-bootc. This is a full OS swap, not an in-place repair: the previous root is preserved read-only under /sysroot after reboot, but nothing else is carried forward automatically — any extra mounts or data outside what's baked into the image need to be accounted for beforehand.
bogreset() {
    local image
    image="$(bootc status --booted --format json | jq -r '.status.booted.image.image.image // empty')"

    if [ -z "$image" ]; then
        echo "Could not determine the currently booted image. Aborting."
        return 1
    fi

    echo "This will DESTRUCTIVELY reinstall this system using: $image"
    echo
    echo "Your current root will be moved to /sysroot (read-only) after reboot, but any mounts or data not defined in the image itself will NOT be carried forward automatically. Back up or account for anything important before continuing."
    echo
    read -rp "Type YES to continue: " confirm
    [ "$confirm" = "YES" ] || { echo "Aborted."; return 1; }

    sudo system-reinstall-bootc "$image"
}

# gtns: Get the new shit.
gtns() {

    echo "GET THE NEW SHIT"

    local uninstall_unused_flatpak=false
    local reboot_when_done=false
    local auto_approve_app_update=false

    read -rp "Uninstall unused Flatpak packages after update? [y/N] " ans1
    [[ "$ans1" =~ ^[Yy]$ ]] && uninstall_unused_flatpak=true

    read -rp "Reboot when done? [y/N] " ans3
    [[ "$ans3" =~ ^[Yy]$ ]] && reboot_when_done=true

    read -rp "Automatically accept app update prompt? [y/N] " ans4
    [[ "$ans4" =~ ^[Yy]$ ]] && auto_approve_app_update=true

    echo "Getting the new shit."
    sudo bootc upgrade

    if $auto_approve_app_update; then
        flatpak update -y
    else
        flatpak update
    fi

    if $uninstall_unused_flatpak; then
        flatpak uninstall --unused
    fi

    if $reboot_when_done; then
        power --reboot
    else
        echo "Shit gotten."
    fi
}

# steam_shortcuts [--list/-l | --flush/-f]
# List Steam shortcuts in menu and an option to fully clear them out (one time I installed a bunch of Steam games, accidentally left the shortcut option on and had like 40 shortcuts made lol, Google fixed it and I wanted to make it a function)
steam_shortcuts() {
    case "${1:-}" in
        --list|-l)
            find "$HOME/.local/share/applications" -name '*.desktop' \
                -exec grep -l 'Exec=steam steam://rungameid/' {} \;
            ;;
        --flush|-f)
            find "$HOME/.local/share/applications" -name '*.desktop' \
                -exec grep -l 'Exec=steam steam://rungameid/' {} \; -delete
            ;;
        *)  echo "Usage: steam_shortcuts [--list/-l | --flush/-f]" ;;
    esac
}

# distroboxes <preset-name>
# Creates a distrobox container based on a preset from the system-managed manifest.
distroboxes() {
    local manifest="/usr/share/bog/distrobox/assemble.ini"
    local preset="${1:-}"
    shift || true
    distrobox assemble create --file "$manifest" --name "$preset" "$@"
}

# getmedia [-v | -a] <url>
# yt-dlp shorthand command (cookies likely needed)
getmedia() {
    local mode="${1:-}"
    shift || true
    case "$mode" in
        --video|-v)
            yt-dlp --format "bestvideo+bestaudio/best" --embed-metadata --embed-thumbnail --embed-subs --embed-chapters "$@"
            ;;
        --audio|-a)
            yt-dlp --format "bestaudio" --embed-metadata --embed-thumbnail --extract-audio --audio-format "mp3" --audio-quality "0" "$@"
            ;;
        *)  echo "Usage: getmedia [--video/-v | --audio/-a] <url>" ;;
    esac
}
