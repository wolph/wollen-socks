#!/usr/bin/env zsh

echo "down"
/usr/bin/killall sockd
rm /up
cp -f /etc/resolv.conf{.backup,}
