# wollen-socks
Simple OpenVPN client Socks proxy server combination which supports both Surfshark and NordVPN currently

Docker Hub link: https://hub.docker.com/repository/docker/wolph/wollen-socks

## Basic usage:

```
docker run \
  -p 1080:1080
  --env VPN_USER=... \
  --env VPN_PASS=... \
  --env VPN_FILE=/surfshark/nl-ams.prod.surfshark.com_udp.ovpn \
  --cap-add NET_ADMIN \
  ghcr.io/wolph/wollen-socks:master
```

After that you can access the server through any client that supports socks:

    curl -vvv -x 'socks5h://127.0.0.1:1080' ifconfig.me 
