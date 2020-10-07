#!/usr/bin/env zsh
setopt shwordsplit

IP_URLS=${IP_URLS:- \
    https://ifconfig.me/ip \
    http://ip1.dynupdate.no-ip.com:8245 \
    http://ip1.dynupdate.no-ip.com \
    https://api.ipify.org \
    https://diagnostic.opendns.com/myip \
    https://domains.google.com/checkip \
    https://ifconfig.io/ip \
    https://ipinfo.io/ip \
}

get_ip(){
  # Convert to array
  IP_URLS=("${(z)IP_URLS}")

  # Get random index
  I=$[$RANDOM % $#IP_URLS + 1]

  # Get random url from the list of urls
  timeout 10s curl --connect-timeout 10 -s "${IP_URLS[$I]}" | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
}

if [ ! -f /base_ip ]; then
  export BASE_IP="$(get_ip)"
  echo "$BASE_IP" > /base_ip
  echo "base ip: $BASE_IP"
else
  export BASE_IP=$(head -n 1 /base_ip)
fi

export HTTP_PROXY=socks5h://localhost:8118
export HTTPS_PROXY=socks5h://localhost:8118
