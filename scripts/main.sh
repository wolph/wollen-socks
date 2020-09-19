#!/usr/bin/env zsh

# Fetch base IP before initializing OpenVPN
. ./get_ip.sh

# Generate random passwords if not given through environment
ROOT_PASSWORD=${ROOT_PASSWORD:-$(pwgen -s 32 1)}
echo "root:$ROOT_PASSWORD" | chpasswd
SOCKD_PASSWORD=${SOCKD_PASSWORD:-$(pwgen -s 32 1)}
echo "sockd:$SOCKD_PASSWORD" | chpasswd
echo "root password: $ROOT_PASSWORD"
echo "sockd password: $SOCKD_PASSWORD"

# Create OpenVPN files
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

# Backup the resolv.conf to restore when the connection goes down
cp /etc/resolv.conf{,.backup}

# Start openvpn and echo show the command
set -v
openvpn \
  --config "$VPN_FILE" \
  --script-security 2 \
  --up /scripts/up.sh \
  --route-up /scripts/route-up.sh \
  --route-delay 1 \
  --route-pre-down /scripts/down.sh \
  --up-restart \
  --ping 10 \
  --ping-restart 10 \
  --persist-tun \
  --auth-user-pass <(echo -e "$VPN_USER\n$VPN_PASS")
