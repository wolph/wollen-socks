# wollen-socks
Simple OpenVPN client Socks proxy server combination which supports both Surfshark and NordVPN currently

Docker Hub link: https://hub.docker.com/repository/docker/wolph/wollen-socks

## Basic usage:

To build:

    docker build -t <image_tag> .
    
To run:

```
docker run \
  -p 1080:1080
  --env VPN_USER=... \
  --env VPN_PASS=... \
  --env VPN_FILE=/surfshark/nl-ams.prod.surfshark.com_udp.ovpn \
  --env SOCKD_PASS=... \
  --cap-add NET_ADMIN \
  wolph/wollen-socks
```

After that you can access the server through any client that supports socks:

    curl -vvv -x 'socks5h://sockd:<password>@127.0.0.1:1080' ifconfig.me 

The password can be specified through the `SOCKD_PASSWORD` value or will be automatically generated and shown in the logs.
