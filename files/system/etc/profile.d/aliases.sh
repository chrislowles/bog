#!/usr/bin/env bash

# power [--reboot/-r | --shutdown/-s]
power() {
    case "${1:-}" in
        --reboot|-r)   systemctl reboot ;;
        --shutdown|-s) systemctl poweroff ;;
        *)  echo "Usage: power [--reboot/-r | --shutdown/-s]" ;;
    esac
}

# gtns: get the new shit
gtns() {
    sudo bootc upgrade
    flatpak update
    read -rp "Uninstall unused packages? [y/N] " gtns1
    if [[ "$gtns1" =~ ^[Yy]$ ]]; then
        flatpak uninstall --unused
    fi
    read -rp "Scan flatpak cache folder for uninstalled app data? [y/N] " gtns2
    if [[ "$gtns2" =~ ^[Yy]$ ]]; then
        flatpak_loosie_collection
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

# setdns --provider <name> [-ipv6-1 <addr>] [-ipv6-2 <addr>] [-ipv4-1 <addr>] [-ipv4-2 <addr>]
#
# Configures DNS for the active NetworkManager connection.
# Supported providers: nextdns (more to be added)
#
# Addresses can be supplied inline via flags, or left out to be prompted interactively.
#
# Examples:
#   setdns --provider nextdns
#   setdns --provider nextdns -ipv6-1 2a07::1 -ipv6-2 2a07::2 -ipv4-1 45.90.28.0 -ipv4-2 45.90.30.0
setdns() {
    local provider="" ipv6_1="" ipv6_2="" ipv4_1="" ipv4_2=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --provider) provider="${2:-}"; shift 2 ;;
            -ipv6-1)    ipv6_1="${2:-}";   shift 2 ;;
            -ipv6-2)    ipv6_2="${2:-}";   shift 2 ;;
            -ipv4-1)    ipv4_1="${2:-}";   shift 2 ;;
            -ipv4-2)    ipv4_2="${2:-}";   shift 2 ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: setdns --provider <name> [-ipv6-1 <addr>] [-ipv6-2 <addr>] [-ipv4-1 <addr>] [-ipv4-2 <addr>]"
                echo "Supported providers: nextdns"
                return 1
                ;;
        esac
    done

    if [[ -z "$provider" ]]; then
        echo "Usage: setdns --provider <name> [-ipv6-1 <addr>] [-ipv6-2 <addr>] [-ipv4-1 <addr>] [-ipv4-2 <addr>]"
        echo "Supported providers: nextdns"
        return 1
    fi

    case "$provider" in
        nextdns)
            echo "Configuring NextDNS..."
            # Prompt for any addresses not supplied via flags
            [[ -z "$ipv6_1" ]] && read -rp "Enter your 1st NextDNS IPv6 address: " ipv6_1
            [[ -z "$ipv6_2" ]] && read -rp "Enter your 2nd NextDNS IPv6 address: " ipv6_2
            [[ -z "$ipv4_1" ]] && read -rp "Enter your 1st NextDNS IPv4 address: " ipv4_1
            [[ -z "$ipv4_2" ]] && read -rp "Enter your 2nd NextDNS IPv4 address: " ipv4_2
            ;;
        *)
            echo "Unknown provider: $provider"
            echo "Supported providers: nextdns"
            return 1
            ;;
    esac

    # Validate that all four addresses were provided
    if [[ -z "$ipv6_1" || -z "$ipv6_2" || -z "$ipv4_1" || -z "$ipv4_2" ]]; then
        echo "Error: all four DNS addresses are required."
        return 1
    fi

    local connection
    connection="$(nmcli -t -f NAME connection show --active | head -1)"

    if [[ -z "$connection" ]]; then
        echo "Error: no active NetworkManager connection found."
        return 1
    fi

    echo "Applying DNS to connection: $connection"
    nmcli connection modify "$connection" \
        ipv6.dns "$ipv6_1 $ipv6_2" ipv6.ignore-auto-dns yes \
        ipv4.dns "$ipv4_1 $ipv4_2" ipv4.ignore-auto-dns yes \
        && nmcli connection up "$connection" \
        && echo "Done. DNS set to $provider on '$connection'."
}

# reapply pre-configurations for an app (if any have been written)
restore_bog_guts() {
    local app_id="$1"

    if [ -z "$app_id" ]; then
        echo "Error: Please provide a Flatpak App ID."
        echo "Example: restore_bog_app com.spotify.Client"
        return 1
    fi

    local skel_dir="/etc/skel/.var/app/$app_id"
    local user_dir="$HOME/.var/app/$app_id"
    local system_override="/usr/share/flatpak/overrides/$app_id"
    local user_override_dir="$HOME/.local/share/flatpak/overrides"

    # Restore skel config if a template exists
    if [ -d "$skel_dir" ]; then
        echo "Restoring skel configuration for $app_id..."
        mkdir -p "$user_dir"
        rsync -av "$skel_dir/" "$user_dir/"
    else
        echo "Note: No skel template found for $app_id - skipping config restore."
    fi

    # Restore bog permissions
    if [ -f "$system_override" ]; then
        echo "Restoring bog permissions for $app_id..."
        mkdir -p "$user_override_dir"
        cp "$system_override" "$user_override_dir/$app_id"
    else
        echo "Note: No system overrides found for $app_id - resolving to clearing any conflicting user permissions..."
        flatpak override --user --reset "$app_id"
    fi

    echo "Done!"
}

# Scans ~/.var/app/ for directories belonging to apps that are no longer installed,
# then prompts to delete them one by one.
# Bazaar has a similar tool but I'd like for GTNS to prompt for something like it as well,
# also sometimes Bazaar misses and a hardline function hits better.
flatpak_loosie_collection() {
    if [[ ! -d "$HOME/.var/app" ]]; then
        echo "No Flatpak app data directory found (~/.var/app doesn't exist)."
        return 0
    fi

    local loosies
    loosies=$(comm -23 \
        <(find "$HOME/.var/app/" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
            | LC_ALL=C sort) \
        <(flatpak list --app --columns=application \
            | grep -E '^[a-zA-Z]' \
            | LC_ALL=C sort))

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
        rm -rf "$HOME/.var/app/${app}"
    done

    echo "Done."
}