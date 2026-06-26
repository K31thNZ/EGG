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

# Allow all traffic on VPN interface
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

# Allow WireGuard port
iptables -A INPUT -p udp --dport 51820 -j ACCEPT

echo "Starting WireGuard interface..."
wg-quick up wg0

# Keep container running
echo "VPN Server is running..."
tail -f /dev/null
