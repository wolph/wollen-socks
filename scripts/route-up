#!/usr/bin/env zsh
set -v
echo "route up"
gateway=$(/sbin/ip route | grep default | awk '{print $3}')
/sbin/ip route add 10.192.0.0/10 via $gateway dev eth0
/usr/sbin/sockd -D
date > /up
