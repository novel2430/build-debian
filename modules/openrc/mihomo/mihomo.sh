#!/sbin/openrc-run

description="Mihomo (Clash Meta), Good Way to Love GFW"

command="/usr/bin/mihomo"
command_args="-d /home/novel2430/clash"
command_user="novel2430:novel2430"

supervisor="supervise-daemon"
supervise_daemon_args="--respawn-delay 3 --respawn-max 0"

output_log="/home/novel2430/.log/mihomo/mihomo.log"
error_log="/home/novel2430/.log/mihomo/mihomo.err"

depend() {
    need network-manager
}
