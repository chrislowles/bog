#!/usr/bin/env bash

## ALIASES
# Custom sudo alias
# Example: pls getmedia -v https://youtu.be/dQw4w9WgXcQ
alias pls="sudo"
# More detailed ls
alias ls="ls -la"

# power [--reboot/-r | --shutdown/-s]
power() {
    case "${1:-}" in
        --reboot|-r)   systemctl reboot ;;
        --shutdown|-s) systemctl poweroff ;;
        *)  echo "Usage: power [--reboot/-r | --shutdown/-s]" ;;
    esac
}

# gtns
gtns() {
    pls bootc upgrade
    flatpak update
    read -rp "Uninstall unused packages? [y/N] " gtns1
    if [[ "$gtns1" =~ ^[Yy]$ ]]; then
        flatpak uninstall --unused
    fi
    read -rp "Remove uninstalled app data? [y/N] " gtns2
    if [[ "$gtns2" =~ ^[Yy]$ ]]; then
        flatpak_loosie_clean
    fi
    read -rp "Reboot? [y/N] " gtns3
    if [[ "$gtns3" =~ ^[Yy]$ ]]; then
        power --reboot
    fi
}

# steam_shortcuts [--list/-l | --flush/-f]
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

# getmedia [-v | -a] <url>
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

# TODO: refactor "set_nextdns" as generic "setdns" function,
# nextdns as a provider under "--provider nextdns" and flags like "-ipv6-1 <1st-ipv6-addr> -ipv6-2 <2nd-ipv6-addr> -ipv4-1 <1st-ipv4-addr> -ipv4-2 <2nd-ipv2-addr>" to expediate the setting being set,
# none written prompts the process to add the addresses as directed below.
set_nextdns() {
    local connection
    connection="$(nmcli -t -f NAME connection show --active | head -1)"

    read -rp "Enter your two NextDNS-provided IPv6 addresses (space-separated): " ipv6_1 ipv6_2
    read -rp "Enter your two NextDNS-provided IPv4 addresses (space-separated): " ipv4_1 ipv4_2

    nmcli connection modify "$connection" \
        ipv6.dns "$ipv6_1 $ipv6_2" ipv6.ignore-auto-dns yes \
        ipv4.dns "$ipv4_1 $ipv4_2" ipv4.ignore-auto-dns yes \
        && nmcli connection up "$connection"
}

# This is simply me automating a part of the process of clearing cache for apps
# scans the list of installed apps against the flatpak app cache directories that still exist.
# Bazaar has a "leftover data" section but I wanted to write a bash function to cover the misses,
# also for GTNS to have prompt for something similar
flatpak_loosie_clean() {
    local loosies
    loosies=$(comm -23 \
        <(ls ~/.var/app/ | sort) \
        <(flatpak list --app --columns=application | sort))

    if [[ -z "$loosies" ]]; then
        echo "No loose app cache folders found."
        return 0
    fi

    echo "Loose Flatpak app cache directories:"

    local to_delete=()
    while IFS= read -r app; do
        read -rp "Delete ~/.var/app/$app ? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            to_delete+=("$app")
        fi
    done <<< "$loosies"

    if [[ ${#to_delete[@]} -eq 0 ]]; then
        echo "Nothing deleted."
        return 0
    fi

    for app in "${to_delete[@]}"; do
        echo "Deleting: ~/.var/app/$app"
        pls rm -rf "~/.var/app/${app}"
    done

    echo "Done."
}