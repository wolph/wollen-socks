FROM alpine

# Automatically kill after set period
# Supports s(econds), m(inutes), h(ours) and d(ays)
ENV TIMEOUT=18h
ENV VPN_FILE=/surfshark/nl-ams.prod.surfshark.com_udp.ovpn
ENV IP_URLS=" \
    https://ifconfig.me/ip \
    http://ip1.dynupdate.no-ip.com:8245 \
    http://ip1.dynupdate.no-ip.com \
    https://api.ipify.org \
    https://diagnostic.opendns.com/myip \
    https://domains.google.com/checkip \
    https://ifconfig.io/ip \
    https://ipinfo.io/ip"
ENV PATH="/scripts:${PATH}"

EXPOSE 1080

RUN apk add curl zsh openvpn unzip tini pwgen busybox-extras

# Duplicated openvpn and privoxy to only install updates
RUN apk --update --no-cache add openvpn dante-server && \
    rm -rf /var/cache/apk/*

RUN mkdir /surfshark && cd /surfshark && \
    curl -s https://my.surfshark.com/vpn/api/v1/server/configurations > configurations.zip && \
    unzip configurations.zip > /dev/null && rm configurations.zip

RUN mkdir /nordvpn && cd /nordvpn && \
    curl -s https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip > ovpn.zip && \
    unzip -j ovpn.zip > /dev/null && rm ovpn.zip

RUN mkdir /scripts
COPY /scripts/* /scripts/
RUN chmod +x /scripts/*
WORKDIR /scripts

COPY sockd.conf /etc/

ENTRYPOINT ["/sbin/tini", "--", "/scripts/main"]
HEALTHCHECK --timeout=5s --start-period=30s CMD /scripts/health
