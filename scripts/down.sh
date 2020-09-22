#!/usr/bin/env zsh
set -v
echo "down"
/usr/bin/killall sockd
rm /up
cp -f /etc/resolv.conf{.backup,}
