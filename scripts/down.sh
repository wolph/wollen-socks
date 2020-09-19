#!/usr/bin/env zsh

echo "down"
/usr/bin/killall sockd
rm /up
cp /etc/resolv.conf{.backup,}
