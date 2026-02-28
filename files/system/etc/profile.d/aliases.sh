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
    yt-dlp --format "bestvideo+bestaudio/best" --embed-metadata --embed-thumbnail --embed-subs --embed-chapters "$@"
}

getmp3() {
    yt-dlp --format "bestaudio" --embed-metadata --embed-thumbnail --extract-audio --audio-format "mp3" --audio-quality "0" "$@"
}

set_nextdns() {
    read -rp "Enter the 2 NextDNS-provided IPv4 addresses (space-separated): " ipv4_1 ipv4_2
    read -rp "Enter the 2 NextDNS-provided IPv6 addresses (space-separated): " ipv6_1 ipv6_2

    local con
    con="$(nmcli -t -f NAME con show --active | head -1)"

    nmcli con mod "$con" \
        ipv4.dns "$ipv4_1 $ipv4_2" \
        ipv4.ignore-auto-dns yes \
        ipv6.dns "$ipv6_1 $ipv6_2" \
        ipv6.ignore-auto-dns yes
    
    nmcli con up "$con"

    echo "DNS updated successfully on: $con"
}