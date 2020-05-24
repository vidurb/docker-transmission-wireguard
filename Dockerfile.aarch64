# based on alpine linux
FROM alpine:latest

# maintainer
LABEL maintainer "Sebastian Danielsson <sebastian.danielsson@protonmail.com>"

# install wireguard-tools transmission-daemon
RUN apk --no-cache --virtual add wireguard-tools transmission-daemon curl git

# copy placeholder config files and startup script from host
COPY root/ .

# create volumes to load config files from host and save downloaded files to host
VOLUME ["/etc/wireguard"]
VOLUME ["/etc/transmission-daemon"]
VOLUME ["/transmission/complete"]
VOLUME ["/transmission/incomplete"]
VOLUME ["/transmission/watch"]

# open ports, 51820 for WireGuard, 9091 for transmission-rpc
EXPOSE 51820/udp 9091

# make the startup script executable and run it
RUN chmod 700 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
