# custom sudo alias, "pls getmp4 https://youtu.be/dQw4w9WgXcQ" for example
alias pls="sudo"

restart() {
    systemctl reboot
}

turnoff() {
    shutdown -n now
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

    echo "NextDNS setup method:"
    echo "  1) IPv6             (recommended - no IP linking required)"
    echo "  2) IPv4 [Linked IP] (fallback - requires linking your IP at my.nextdns.io)"
    read -rp "Choose [1/2]: " method

    case "$method" in
        1)
            read -rp "Enter your two NextDNS-provided IPv6 addresses (space-separated): " ipv6_1 ipv6_2
            nmcli connection modify "$connection" \
                ipv6.dns "$ipv6_1 $ipv6_2" \
                ipv6.ignore-auto-dns yes \
                && nmcli connection up "$connection"
            ;;
        2)
            echo "Note: Linked IP ties NextDNS to your current public IP."
            echo "      Not recommended for mobile or networks where your IP changes frequently."
            echo "      Make sure your IP is linked at: https://my.nextdns.io"
            read -rp "Enter your two NextDNS IPv4 addresses (space-separated): " ipv4_1 ipv4_2
            nmcli connection modify "$connection" \
                ipv4.dns "$ipv4_1 $ipv4_2" \
                ipv4.ignore-auto-dns yes \
                && nmcli connection up "$connection"
            ;;
        *)
            echo "Invalid choice. Aborting." >&2
            return 1
            ;;
    esac
}

get_the_new_shit() {
    pls bootc upgrade
    flatpak update
}