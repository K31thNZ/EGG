#!/bin/bash

set -e

echo "Starting WireGuard VPN Server..."

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

# Setup NAT masquerading
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A FORWARD -o wg0 -j ACCEPT
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

echo "Starting WireGuard interface..."
wg-quick up wg0

echo "Starting UDP2RAW tunnel..."
# This wraps UDP WireGuard traffic in TCP
udp2raw --server --listen 0.0.0.0:51820 --raw 127.0.0.1:51820 \
    --cipher-mode xor --auth-mode simple \
    --log-level 2 &

echo "VPN Server is running on TCP port 51820"
echo "Connect using udp2raw client + WireGuard client"

tail -f /dev/null
