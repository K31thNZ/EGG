#!/bin/bash

# Run this script LOCALLY to generate keys
# DO NOT deploy this file to GitHub

echo "Generating WireGuard keys..."

# Generate server keys
SERVER_PRIVATE_KEY=$(wg genkey)
SERVER_PUBLIC_KEY=$(echo $SERVER_PRIVATE_KEY | wg pubkey)

# Generate client keys
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)

echo ""
echo "=== SERVER KEYS ==="
echo "Server Private Key: $SERVER_PRIVATE_KEY"
echo "Server Public Key:  $SERVER_PUBLIC_KEY"
echo ""
echo "=== CLIENT KEYS ==="
echo "Client Private Key: $CLIENT_PRIVATE_KEY"
echo "Client Public Key:  $CLIENT_PUBLIC_KEY"
echo ""
echo "=== CLIENT CONFIGURATION ==="
echo "Copy this to your client device:"
echo ""
cat << EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = 10.13.13.2/24
DNS = 1.1.1.1, 1.0.0.1
MTU = 1420

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = YOUR_RENDER_URL.onrender.com:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF
