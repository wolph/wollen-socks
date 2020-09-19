# wollen-socks
Simple OpenVPN client Socks proxy server combination which supports both Surfshark and NordVPN currently

## Basic usage:

To build:

    docker build -t <image_tag> .
    
To run:

```
docker run
-p 1080:1080
--env VPN_USER=...
--env VPN_PASS=...
--env VPN_FILE=/surfshark/nl-ams.prod.surfshark.com_udp.ovpn
--env SOCKD_PASSWORD=...
--cap-add NET_ADMIN
<image_tag> 
```

After that you can access the server through any client that supports socks:

    curl -vvv -x 'socks5h://sockd:T2ufrTZsOnpTE3oNW81OHpkQRehd0Sc4@127.0.0.1:1080' ifconfig.me 
