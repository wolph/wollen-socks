#!/usr/bin/env zsh

# Fetch base IP before initializing OpenVPN
. ./get_ip.sh

# Generate random passwords if not given through environment
ROOT_PASS=${ROOT_PASS:-$(pwgen -s 32 1)}
echo "root:$ROOT_PASS" | chpasswd
SOCKD_PASS=${SOCKD_PASS:-$(pwgen -s 32 1)}
echo "sockd:$SOCKD_PASS" | chpasswd
echo "root password: $ROOT_PASS"
echo "sockd password: $SOCKD_PASS"
echo "root proxy url: socks5h://root:$ROOT_PASS@127.0.0.1:1080"
echo "sockd proxy url: socks5h://sockd:$SOCKD_PASS@127.0.0.1:1080"

# Compatibility with older format
VPN_USER=${VPN_USER:-$USER}
VPN_PASS=${VPN_PASS:-$PASSWORD}

echo "user: $VPN_USER :: $VPN_PASS"

OPENVPN_ARGS=${OPENVPN_ARGS:-}
echo "shell: $SHELL"

if [ "$SHELL" ]; then
  OPENVPN_ARGS="${OPENVPN_ARGS} --daemon"
fi

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
  --auth-user-pass <(echo -e "$VPN_USER\n$VPN_PASS") \
  $OPENVPN_ARGS

if [ "$SHELL" ]; then
  exec zsh
fi
