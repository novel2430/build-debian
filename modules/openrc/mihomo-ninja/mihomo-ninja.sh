#!/sbin/openrc-run

description="Mihomo Ninja (Clash Meta), Good Way to Love GFW"

command="/usr/local/bin/mihomo-ninja"
command_args="-d /home/novel2430/clash"
command_user="novel2430:novel2430"

supervisor="supervise-daemon"
supervise_daemon_args="--respawn-delay 3 --respawn-max 0"

output_log="/home/novel2430/.log/mihomo-ninja/mihomo.log"
error_log="/home/novel2430/.log/mihomo-ninja/mihomo.err"

depend() {
    need network-manager
}
