#!/usr/bin/env zsh

. ./get_ip.sh
IP="$(get_ip)"

if [ "$IP" = "$BASE_IP" ]; then
  echo "VPN not working, got ip: $IP"
  exit 1
elif [ -z "$IP" ]; then
  echo "Unable to get ip, base ip: $BASE_IP"
  exit 2
else
  echo "ip: $IP, base ip: $BASE_IP"
  exit 0
fi
