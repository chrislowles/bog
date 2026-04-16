#!/usr/bin/env bash

## ALIASES
# Custom sudo alias
# Example: pls get -v https://youtu.be/dQw4w9WgXcQ
alias pls="sudo"
# More detailed ls
alias ls="ls -la"

# power [--reboot/-r | --shutdown/-s]
power() {
    case "${1:-}" in
        --reboot)   systemctl reboot ;;
        --shutdown) systemctl poweroff ;;
        *)  echo "Usage: power [--reboot/-r | --shutdown/-s]" ;;
    esac
}

# get_the_new_shit
get_the_new_shit() {
    pls bootc upgrade
    flatpak update
    local mode="${1:-}"
    shift || true
    case "$mode" in
        --menu|--reboot|-r)
            read -rp "Reboot? [y/N] " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                power --reboot
            fi
            ;;
    esac
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

# get [--video/-v | --audio/-a] <url>
get() {
    local mode="${1:-}"
    shift || true
    case "$mode" in
        --video|-v)
            yt-dlp --format "bestvideo+bestaudio/best" --embed-metadata --embed-thumbnail --embed-subs --embed-chapters "$@"
            ;;
        --audio|-a)
            yt-dlp --format "bestaudio" --embed-metadata --embed-thumbnail --extract-audio --audio-format "mp3" --audio-quality "0" "$@"
            ;;
        *)  echo "Usage: get [--video/-v | --audio/-a] <url>" ;;
    esac
}

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

# For when the official pkg data removal tools aren't enough (ytmd client cough cough)
flatpak_clean_orphans() {
    local orphans
    orphans=$(comm -23 \
        <(ls ~/.var/app/ | sort) \
        <(flatpak list --app --columns=application | sort))

    if [[ -z "$orphans" ]]; then
        echo "No orphaned app data found."
        return 0
    fi

    echo "Orphaned Flatpak app data directories:"

    local to_delete=()
    while IFS= read -r app; do
        read -rp "Delete ~/.var/app/$app ? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            to_delete+=("$app")
        fi
    done <<< "$orphans"

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