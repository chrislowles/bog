# custom sudo alias, "pls getmp4 https://youtu.be/dQw4w9WgXcQ" for example
alias pls="sudo"
alias ls="ls -la"

restart() {
    systemctl reboot
}

turnoff() {
    shutdown -n now
}

gethenewshit() {
    pls bootc upgrade
    flatpak update
}

# preset arch linux distrobox cmd
distrobox_arch_create() {
    distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git"
}

distrobox_arch_enter() {
    distrobox enter arch
}

distrobox_arch_yay() {
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
}

getmp4() {
    yt-dlp --format "bestvideo+bestaudio/best" --embed-metadata --embed-thumbnail --embed-subs --embed-chapters "$@"
}

getmp3() {
    yt-dlp --format "bestaudio" --embed-metadata --embed-thumbnail --extract-audio --audio-format "mp3" --audio-quality "0" "$@"
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

# for when orphaned pkg removal isn't enough (ytmd client cough cough)
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

    echo "Deleting:"
    for app in "${to_delete[@]}"; do
        echo "  ~/.var/app/$app"
        pls rm -rf "~/.var/app/${app}"
    done
    echo "Done."
}