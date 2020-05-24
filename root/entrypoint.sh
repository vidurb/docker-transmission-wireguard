#!/bin/sh

# check for wireguard config, then start wireguard
cd /etc/wireguard

if [ ! -f wg0.conf ]
then
  echo "Could not find wg0.conf."
fi

if [ -f wg0.conf ]
then
    chmod 600 wg0.conf
    wg-quick up wg0
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

# start transmission
exec /usr/bin/transmission-daemon --foreground --config-dir /etc/transmission-daemon
