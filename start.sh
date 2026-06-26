#!/bin/bash

echo "Starting WireGuard VPN Server..."

# Enable IP forwarding via sysctl only
sysctl -w net.ipv4.ip_forward=1 2>/dev/null || echo "Warning: Could not enable IP forwarding via sysctl"

# Try alternate method for IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null || echo "Warning: Could not set /proc/sys/net/ipv4/ip_forward"

# Setup iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || echo "Warning: iptables rule failed"
iptables -A FORWARD -i wg0 -j ACCEPT 2>/dev/null || echo "Warning: iptables rule failed"
iptables -A FORWARD -o wg0 -j ACCEPT 2>/dev/null || echo "Warning: iptables rule failed"
iptables -A INPUT -i wg0 -j ACCEPT 2>/dev/null || echo "Warning: iptables rule failed"
iptables -A OUTPUT -o wg0 -j ACCEPT 2>/dev/null || echo "Warning: iptables rule failed"

# Start WireGuard
echo "Bringing up WireGuard interface..."
wg-quick up wg0 2>&1

# Start UDP2RAW tunnel
echo "Starting UDP2RAW tunnel..."
udp2raw --server --listen 0.0.0.0:51820 --raw 127.0.0.1:51820 \
    --cipher-mode xor --auth-mode simple \
    --log-level 2 &

echo "VPN Server is running!"

# Keep alive
while true; do sleep 3600; done
