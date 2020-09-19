#!/usr/bin/env zsh

. ./get_ip.sh
IP="$(get_ip)"

if [ "$IP" = "$BASE_IP" ]; then
  echo 'VPN not working'
  exit 1
elif [ -z "$IP" ]; then
  echo 'Unable to get IP'
  exit 2
else
  echo "IP: $IP"
  exit 0
fi
