#!/usr/bin/env zsh

echo "up"
echo > /etc/resolv.conf
echo nameserver 8.8.8.8 >> /etc/resolv.conf
echo nameserver 8.8.4.4 >> /etc/resolv.conf
echo nameserver 1.1.1.1 >> /etc/resolv.conf
echo nameserver 1.0.0.1 >> /etc/resolv.conf
