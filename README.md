# wireguard-transmission

A Docker/OCI image running the Transmission BitTorrent client through a WireGuard tunnel.

![View on DockerHub](https://img.shields.io/static/v1?label=DockerHub&message=View&color=blue&logo=docker&style=social)

Forked from SebDanielsson's [image](https://github.com/SebDanielsson/docker-wireguard-transmission),
and with Haugene's [image](https://github.com/haugene/docker-transmission-openvpn) as a source for some feature additions. Many thanks to them & all contributors to their repositories.

WireGuard is copyright of Jason A. Donenfeld.

~~Warning: This image is currently under active development and is not fully tested.
This warning will be removed once the image is tested. In the meantime, please open
an issue if you encounter any bugs.~~

This image is now tested and working, and as such the first version has been released. 
Right now I've only tested it on `amd64` because that's all I have access to; if you
have used the image on a different architecture and it works please do let me know by filing an issue.
A friend with access to a Raspberry Pi has agreed to test it on `arm64`, so I hope
to have that confirmed soon.

Built using GitHub Actions: 

![GitHub Workflow Status - build-release](https://img.shields.io/github/workflow/status/vidurb/docker-wireguard-transmission/build-release?label=Versioned%20Build&style=social&logo=github-actions)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/vidurb/wireguard-transmission?sort=semver&style=social&logo=docker)

![GitHub Workflow Status - build-develop](https://img.shields.io/github/workflow/status/vidurb/docker-wireguard-transmission/build-develop?label=Development%20Build&style=social&logo=github-actions)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/vidurb/wireguard-transmission?sort=date&style=social&logo=docker)

## Features:
- Runs `transmission-daemon` (latest version) on Alpine Linux
- WireGuard tunnel is set up using `wg-quick` & a mounted configuration file
- Uses the [combustion](https://github.com/Secretmapper/combustion) web UI and the excellent [dark theme](https://github.com/SebDanielsson/dark-combustion) for the same.
- Can run `transmission-daemon` as a non-root user with custom UID and GID.
- Built for multiple architectures (Warning! Only the amd64 images are tested at
this point in time)
- Generates the transmission configuration file from environment variables (as
described below).

### To-Do:
- [x] Test whether the image can be run without `privileged` mode by using `cap_add`
to add specific capabilities for greater security.

## Usage

* Mount your WireGuard configuration file into the `/etc/wireguard/` folder and
 set the name of the file (without the extension) as the `INTERFACE` environment
  variable.
* You can either choose to mount your settings file into the container or
 configure Transmission using environment variables. 
    * To mount your settings file into the container, set a bind mount for 
    `$TRANSMISSION_HOME/settings.json`. (Replace `$TRANSMISSION_HOME` with the
    default value as given below or whatever custom value you choose.)
    * To configure Transmission using environment variables, set variables for
    the settings that you'd like to change from the defaults (see the table
    below for reference). Setting the `TRANSMISSION_RPC_PASSWORD` and
    `TRANSMISSION_RPC_USERNAME` at the very least is recommended.
    * Once a configuration file has been generated, the container will not
    regenerate the file unless `OVERWRITE_CONFIGURATION` is passed in.
    * It's simplest to modify Transmission settings using the web UI.
* Setting the `KILLSWITCH` variable to any value will ensure Transmission only
runs through the WireGuard tunnel.
* By default, download-related folders are in `/data` and transmission's
configuration directory is `/data/transmission-home`. Please adjust the mounts
in the examples below accordingly if you choose to change the structure.
* Note that the `NET_ADMIN` capability and `net.ipv4.conf.all.src_valid_mark` are
required to be set for the WireGuard tunnel to work.
* Also, in order for the container's web UI to be accessible from other docker 
containers or your local network, you may need to add something similar to the 
following to your wireguard configuration.

```
PostUp = DROUTE=$(ip route | grep default | awk '{print $3}'); HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route add $HOMENET3 via $DROUTE;ip route add $HOMENET2 via $DROUTE; ip route add $HOMENET via $DROUTE;iptables -I OUTPUT -d $HOMENET -j ACCEPT;iptables -A OUTPUT -d $HOMENET2 -j ACCEPT; iptables -A OUTPUT -d $HOMENET3 -j ACCEPT;  iptables -A OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT
PreDown = HOMENET=192.168.0.0/16; HOMENET2=10.0.0.0/8; HOMENET3=172.16.0.0/12; ip route del $HOMENET3 via $DROUTE;ip route del $HOMENET2 via $DROUTE; ip route del $HOMENET via $DROUTE; iptables -D OUTPUT ! -o %i -m mark ! --mark $(wg show %i fwmark) -m addrtype ! --dst-type LOCAL -j REJECT; iptables -D OUTPUT -d $HOMENET -j ACCEPT; iptables -D OUTPUT -d $HOMENET2 -j ACCEPT; iptables -D OUTPUT -d $HOMENET3 -j ACCEPT
```

### docker run
```
docker run --name wireguard-transmission \
--cap-add=NET_ADMIN \
--sysctl net.ipv4.conf.all.src_valid_mark=1 \
-e "TRANSMISSION_RPC_USERNAME=transmission" \
-e "TRANSMISSION_RPC_PASSWORD=transmission" \
-e "INTERFACE=wg0" \
-e "KILLSWITCH=yes" \
-p 51820:51820/udp \
-p 9091:9091 \
-v /path/to/wg-conf-dir:/etc/wireguard \
-v /path/to/transmission-dir:/data \
vidurb/wireguard-transmission
```

### docker-compose.yml
```
version: '3.7'
services:
    wireguard-transmission:
        image: vidurb/wireguard-transmission
        container_name: wireguard-transmission
        environment:
            - TRANSMISSION_RPC_USERNAME=transmission
            - TRANSMISSION_RPC_PASSWORD=transmission
            - INTERFACE=wg0
            - KILLSWITCH=yes
        cap_add:
            - NET_ADMIN
        sysctls:
            - net.ipv4.conf.all.src_valid_mark=1
        ports:
            - '51820:51820/udp'
            - '9091:9091'
        volumes:
            - '/path/to/wg-conf-dir:/etc/wireguard'
            - '/path/to/transmission-dir:/data'
```

# Environment Variables

| Variable  | Default | Description |
| ------------- | ------------- | ------------- |
| GLOBAL_APPLY_PERMISSIONS  | true  | Apply permissions for custom user to all folders (only applies when PUID is set) |
| PUID  | none  | UID to run containerized process as |
| PGID  | none  | GID to run containerized process as |
| OVERWRITE_CONFIGURATION  | none  | Overwrite Transmission's configuration file if it already exists |
| INTERFACE | wg0 | Name of wireguard configuration file |
| KILLSWITCH | none | Whether to bind Transmission to WireGuard IP |
| TRANSMISSION_ALT_SPEED_DOWN  | 50  | Alternate download speed limit |
| TRANSMISSION_ALT_SPEED_ENABLED  | false  | Enable alternate speed limit |
| TRANSMISSION_ALT_SPEED_TIME_BEGIN  | 540  | Start time for alternate speed limit |
| TRANSMISSION_ALT_SPEED_TIME_DAY  | 127  | Days to enable alternate speed limit, see [Transmission docs](https://github.com/transmission/transmission/wiki/Editing-Configuration-Files)  |
| TRANSMISSION_ALT_SPEED_TIME_ENABLED  | false  | Toggle the `TRANSMISSION_ALT_SPEED_ENABLED` based on time  |
| TRANSMISSION_ALT_SPEED_TIME_END  | 1020  | End time for alternate speed limit |
| TRANSMISSION_ALT_SPEED_UP  | 50  | Alternate upload speed limit |
| TRANSMISSION_BIND_ADDRESS_IPV4  | 0.0.0.0  | Force Transmission to bind to a particular IP |
| TRANSMISSION_BIND_ADDRESS_IPV6  | ::  | Force Transmission to bind to a particular IP |
| TRANSMISSION_BLOCKLIST_ENABLED  | false  | Enable blocking of peers based on blocklist |
| TRANSMISSION_BLOCKLIST_URL  | http://www.example.com/blocklist  | Blocklist URL |
| TRANSMISSION_CACHE_SIZE_MB  | 4  | Transmission's disk cache size (megabytes) |
| TRANSMISSION_DHT_ENABLED  | true  | Enable BitTorrent DHT |
| TRANSMISSION_DOWNLOAD_DIR  | /data/completed  | Folder to move completed downloads to |
| TRANSMISSION_DOWNLOAD_QUEUE_ENABLED  | true  | Enable download queuing  |
| TRANSMISSION_DOWNLOAD_QUEUE_SIZE  | 5  | Number of concurrent downloads to allow |
| TRANSMISSION_ENCRYPTION  | 1  | 0 = Prefer unencrypted connections, 1 = Prefer encrypted connections, 2 = Require encrypted connections |
| TRANSMISSION_IDLE_SEEDING_LIMIT  | 30  | Stop seeding after being idle for N minutes |
| TRANSMISSION_IDLE_SEEDING_LIMIT_ENABLED  | false  | Enable stopping seeding after being idle for `TRANSMISSION_IDLE_SEEDING_LIMIT` minutes |
| TRANSMISSION_INCOMPLETE_DIR  | /data/incomplete  | Directory to store incomplete downloads |
| TRANSMISSION_INCOMPLETE_DIR_ENABLED  | true  | Enable separate directory for incomplete downloads |
| TRANSMISSION_LPD_ENABLED  | false  | Enable Local Peer Discovery |
| TRANSMISSION_MESSAGE_LEVEL  | 2  | 0 = None, 1 = Error, 2 = Info, 3 = Debug (set verbosity of transmission logs) |
| TRANSMISSION_PEER_CONGESTION_ALGORITHM  | none  | This is documented [here](http://www.pps.jussieu.fr/~jch/software/bittorrent/tcp-congestion-control.html) |
| TRANSMISSION_PEER_ID_TTL_HOURS  | 6  | Recycle the peer id used for public torrents after N hours of use |
| TRANSMISSION_PEER_LIMIT_GLOBAL  | 200  | Global peer limit |
| TRANSMISSION_PEER_LIMIT_PER_TORRENT  | 50  | Peer limit per torrent |
| TRANSMISSION_PEER_PORT  | 51413  | Peer communication port |
| TRANSMISSION_PEER_PORT_RANDOM_HIGH  | 65535  | End of range for random peer port |
| TRANSMISSION_PEER_PORT_RANDOM_LOW  | 49152  | Start of range for random peer port |
| TRANSMISSION_PEER_PORT_RANDOM_ON_START  | false  | Randomize peer port on startup |
| TRANSMISSION_PEER_SOCKET_TOS  | default  | Set the [TOS](http://en.wikipedia.org/wiki/Type_of_Service) for outgoing packets. Possible values are `default`,`lowcost`,`throughput`,`lowdelay` and `reliablility` |
| TRANSMISSION_PEX_ENABLED  | true  | Enable Peer Exchange |
| TRANSMISSION_PORT_FORWARDING_ENABLED  | false  | Enable [UPnP](http://en.wikipedia.org/wiki/Universal_Plug_and_Play) or [NAT-PMP](http://en.wikipedia.org/wiki/NAT_Port_Mapping_Protocol) |
| TRANSMISSION_PREALLOCATION  | 1  | 0 = Off, 1 = Fast, 2 = Full (slower but reduces disk fragmentation) |
| TRANSMISSION_PREFETCH_ENABLED  | 1  | When enabled, Transmission will hint to the OS which piece data it's about to read from disk in order to satisfy requests from peers |
| TRANSMISSION_QUEUE_STALLED_ENABLED  | true  | When true, torrents that have not shared data for `TRANSMISSION_QUEUE_STALLED_MINUTES` are treated as 'stalled' and are not counted against the queue-download-size and seed-queue-size limits |
| TRANSMISSION_QUEUE_STALLED_MINUTES  | 30  | See `TRANSMISSION_QUEUE_STALLED_ENABLED` |
| TRANSMISSION_RATIO_LIMIT  | 2  | Maximum torrent dl/ul ratio |
| TRANSMISSION_RATIO_LIMIT_ENABLED  | false  | Enablle `TRANSMISSION_RATIO_LIMIT` |
| TRANSMISSION_RENAME_PARTIAL_FILES  | true  | Postfix partially downloaded files with ".part" |
| TRANSMISSION_RPC_AUTHENTICATION_REQUIRED  | false  | Require authentication for RPC interface |
| TRANSMISSION_RPC_BIND_ADDRESS  | 0.0.0.0  | RPC interface bind address |
| TRANSMISSION_RPC_ENABLED  | true  | Enable RPC interface |
| TRANSMISSION_RPC_HOST_WHITELIST  | none  | Comma-delimited list of domain names. Wildcards allowed using '*'. Example: "*.foo.org,example.com", Default: "", Always allowed: "localhost", "localhost.", all the IP addresses |
| TRANSMISSION_RPC_HOST_WHITELIST_ENABLED  | false  | Enable RPC host whitelist |
| TRANSMISSION_RPC_PASSWORD  | password  | RPC password |
| TRANSMISSION_RPC_PORT  | 9091  | RPC port |
| TRANSMISSION_RPC_URL  | /transmission/  | RPC URL prefix - do not change this, there is a [bug in Combustion](https://github.com/Secretmapper/combustion/issues/52) |
| TRANSMISSION_RPC_USERNAME  | username  | RPC username |
| TRANSMISSION_RPC_WHITELIST  | 127.0.0.1  | Comma-delimited list of IP addresses. Wildcards allowed using '\*'. |
| TRANSMISSION_RPC_WHITELIST_ENABLED  | false  | Enable RPC whitelist (all connections allowed if disabled) |
| TRANSMISSION_SCRAPE_PAUSED_TORRENTS_ENABLED  | true  | Whether to scrape paused torrents |
| TRANSMISSION_SCRIPT_TORRENT_DONE_ENABLED  | false  | Run a script at torrent completion |
| TRANSMISSION_SCRIPT_TORRENT_DONE_FILENAME  | none  | Path to script to run at torrent completion |
| TRANSMISSION_SEED_QUEUE_ENABLED  | false  | Enable queue for torrents being seeded |
| TRANSMISSION_SEED_QUEUE_SIZE  | 10  | Queue size for `TRANSMISSION_SEED_QUEUE_ENABLED` |
| TRANSMISSION_SPEED_LIMIT_DOWN  | 100  | Download speed limit |
| TRANSMISSION_SPEED_LIMIT_DOWN_ENABLED  | false  | Enable `TRANSMISSION_SPEED_LIMIT_DOWN` |
| TRANSMISSION_SPEED_LIMIT_UP  | 100  | Upload speed limit |
| TRANSMISSION_SPEED_LIMIT_UP_ENABLED  | false  | Enable `TRANSMISSION_SPEED_LIMIT_UP` |
| TRANSMISSION_START_ADDED_TORRENTS  | true  | Automatically start torrents when added |
| TRANSMISSION_TRASH_ORIGINAL_TORRENT_FILES  | false  | Delete original torrent files |
| TRANSMISSION_UMASK  | 2  | Sets transmission's file mode creation mask.  Bear in mind that the json markup language only accepts numbers in base 10, so the standard umask(2) octal notation "022" is written in settings.json as 18 |
| TRANSMISSION_UPLOAD_SLOTS_PER_TORRENT  | 14  | Number of upload slots per torrent |
| TRANSMISSION_UTP_ENABLED  | false  | Enable [Micro Transport Protocol](http://en.wikipedia.org/wiki/Micro_Transport_Protocol) |
| TRANSMISSION_WATCH_DIR  | /data/watch  | Directory to watch for torrent files |
| TRANSMISSION_WATCH_DIR_ENABLED  | true  | Enable `TRANSMISSION_WATCH_DIR` |
| TRANSMISSION_HOME  | /data/transmission-home  | Transmission home dir |
| TRANSMISSION_WATCH_DIR_FORCE_GENERIC  | false  | Force scanning of watch dir every 10 seconds (use if the watch dir is not working) |

