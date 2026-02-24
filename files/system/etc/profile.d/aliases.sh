alias pls="sudo"

distrobox_arch_create() {
    distrobox create --pull -Y -n arch -i archlinux:latest -ap "base-devel git" -- bash -c "distrobox_arch_enter;distrobox_arch_yay;echo 'You can now install AUR packages!"
}

distrobox_arch_enter() {
    distrobox enter arch
}

distrobox_arch_yay() {
    git clone https://aur.archlinux.org/yay-bin.git -- bash -c "cd yay-bin;makepkg -si"
}

getmp4() {
    yt-dlp --format "bestvideo+bestaudio/best" --embed-subs --embed-thumbnail --embed-metadata --embed-chapters "$@"
}

getmp3() {
    yt-dlp --format "bestaudio" --extract-audio --audio-format "mp3" --audio-quality "0" --embed-thumbnail --embed-metadata "$@"
}

set_nextdns() {
    read -rp "Enter NextDNS-provided IPv4 addresses (space-separated): " ipv4_1 ipv4_2
    read -rp "Enter NextDNS-provided IPv6 addresses (space-separated): " ipv6_1 ipv6_2

    local con
    con="$(nmcli -t -f NAME con show --active | head -1)"

    nmcli con mod "$con" \
        ipv4.dns "$ipv4_1 $ipv4_2" \
        ipv4.ignore-auto-dns yes \
        ipv6.dns "$ipv6_1 $ipv6_2" \
        ipv6.ignore-auto-dns yes \
        && nmcli con up "$con" \
        && echo "DNS updated successfully on: $con"
}

bfp_cpr() {

    ### UNFINISHED EMERGENCY REBOOT FUNCTION FOR FLATPAK AND BAZAAR

    echo "=== FLATPAK/BAZAAR CPR ==="
    sleep 2

    echo "FLATPAK/BAZAAR CPR: Attempting to kill and revive processes..."
    pls pkill -9 -f flatpak
    pls pkill -9 -f bazaar
    pls pkill -9 -f flatpak-system-helper

    echo "FLATPAK/BAZAAR CPR: rm -f /var/lib/flatpak/.changed"
    pls rm -f /var/lib/flatpak/.changed

    pls mkdir -p /etc/bazzite

    echo "9" | pls tee /etc/bazzite/flatpak_manager_version
    mount | grep revokefs

    echo "FLATPAK/BAZAAR CPR: Killed flatpak and Bazaar processes"

    pls flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "FLATPAK/BAZAAR CPR: Reimported Flathub repo"

    flatpak repair
    echo "FLATPAK/BAZAAR CPR: Attempted to repair flatpak apps"

    flatpak update --appstream
    echo "FLATPAK/BAZAAR CPR: Updated flatpak apps (appstream)"

    # Refresh application launcher cache (currently kde plasma, looking to change to refreshing the gnome menu cache if needed)
    if command -v kbuildsycoca6 &> /dev/null; then
        echo "FLATPAK/BAZAAR CPR: Refreshing application launcher cache."
        kbuildsycoca6 &>/dev/null
    elif command -v kbuildsycoca5 &> /dev/null; then
        echo "FLATPAK/BAZAAR CPR: Refreshing application launcher cache."
        kbuildsycoca5 &>/dev/null
    fi

}