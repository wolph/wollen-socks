#!/usr/bin/env zsh

# Fetch base IP before initializing OpenVPN
. ./get_ip.sh

echo "proxy url: socks5h://127.0.0.1:1080"
echo "config: $VPN_FILE"

# Compatibility with older format
VPN_USER=${VPN_USER:-$USER}
VPN_PASS=${VPN_PASS:-$PASSWORD}
OPENVPN_ARGS=${OPENVPN_ARGS:-}

if [ "$SHELL" ]; then
  OPENVPN_ARGS="${OPENVPN_ARGS} --daemon"
fi

# Create OpenVPN files
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

# Backup the resolv.conf to restore when the connection goes down
cp /etc/resolv.conf{,.backup}

echo "IP: $(get_ip)"

# Start openvpn and echo show the command
set -v
timeout $TIMEOUT openvpn \
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
  --auth-user-pass <(echo -e "$VPN_USER\n$VPN_PASS") \
  $OPENVPN_ARGS

if [ "$SHELL" ]; then
  exec zsh
fi
