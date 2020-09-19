FROM alpine

ENV VPN_USER username
ENV VPN_PASS password
ENV VPN_FILE /surfshark/nl-ams.prod.surfshark.com_udp.ovpn
ENV IP_URLS \
    https://ifconfig.me/ip \
    http://ip1.dynupdate.no-ip.com:8245 \
    http://ip1.dynupdate.no-ip.com \
    https://api.ipify.org \
    https://diagnostic.opendns.com/myip \
    https://domains.google.com/checkip \
    https://ifconfig.io/ip \
    https://ipinfo.io/ip

EXPOSE 1080

RUN apk add curl zsh openvpn unzip wget busybox-extras shadow tini tzdata pwgen

# Duplicated openvpn and privoxy to only install updates
RUN apk --update --no-cache add openvpn dante-server && \
    rm -rf /var/cache/apk/*

RUN mkdir /surfshark && cd /surfshark && \
    wget -q -O configurations https://my.surfshark.com/vpn/api/v1/server/configurations && \
    unzip configurations > /dev/null && rm configurations

RUN mkdir /nordpvn && cd /nordpvn && \
    wget -q -O ovpn.zip https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip && \
    unzip ovpn.zip > /dev/null && rm ovpn.zip

RUN mkdir /scripts
COPY /scripts/* /scripts/
RUN chmod +x /scripts/*
COPY sockd.conf /etc/
WORKDIR /scripts
ENTRYPOINT ["/sbin/tini", "--", "/scripts/main.sh"]
HEALTHCHECK --timeout=10s --start-period=30s CMD /sbin/tini -- /scripts/health.sh
