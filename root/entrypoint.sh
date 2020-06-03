#!/bin/sh

# check for wireguard config, then start wireguard
if [ ! -f /etc/wireguard/"$INTERFACE".conf ]
then
  echo "Could not find /etc/wireguard/"$INTERFACE".conf"
fi

if [ -f /etc/wireguard/"$INTERFACE".conf ]
then
    chmod 600 /etc/wireguard/"$INTERFACE".conf
    wg-quick up "$INTERFACE"
fi

# make transmission only use the wireguard interface
if [ ! -z "$KILLSWITCH" ]; then
	WIREGUARDIPV4=$(ip addr show "$KILLSWITCH" | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
	WIREGUARDIPV6=$(ip addr show "$KILLSWITCH" | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d')
	sed -i "/bind-address-ipv4/c\    \"bind-address-ipv4\": \"$WIREGUARDIPV4\"," /etc/transmission-daemon/settings.json
	sed -i "/bind-address-ipv6/c\    \"bind-address-ipv6\": \"$WIREGUARDIPV6\"," /etc/transmission-daemon/settings.json
fi

# download Secretmapper/combustion, a great looking transmisison web interface, then apply SebDanielsson/dark-combustion, dark theme for combustion
cd /usr/share/transmission/web
rm -rf * && \
wget https://github.com/Secretmapper/combustion/archive/release.zip && \
unzip release.zip && \
mv combustion-release/* ./
rm release.zip
rmdir combustion-release
curl https://raw.githubusercontent.com/SebDanielsson/dark-combustion/master/main.77f9cffc.css > main.77f9cffc.css

# change rpc-username and rpc-password
if [ ! -z "$USERNAME" ] && [ ! -z "$PASSWORD" ]; then
	sed -i '/rpc-authentication-required/c\    "rpc-authentication-required": true,' /etc/transmission-daemon/settings.json
	sed -i "/rpc-username/c\    \"rpc-username\": \"$USERNAME\"," /etc/transmission-daemon/settings.json
	sed -i "/rpc-password/c\    \"rpc-password\": \"$PASSWORD\"," /etc/transmission-daemon/settings.json
fi

# start transmission
exec /usr/bin/transmission-daemon --foreground --config-dir /etc/transmission-daemon
