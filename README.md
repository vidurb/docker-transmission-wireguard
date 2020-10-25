# wireguard-transmission

[![GitHub](https://img.shields.io/badge/github-blue?style=flat&color=grey&logo=GitHub)](https://github.com/vidurb/docker-wireguard-transmission)
[![GitHub stars](https://img.shields.io/github/stars/vidurb/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/vidurb/docker-wireguard-transmission/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/vidurb/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/vidurb/docker-wireguard-transmission/issues)
[![GitHub forks](https://img.shields.io/github/forks/vidurb/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/vidurb/docker-wireguard-transmission/network)
[![GitHub license](https://img.shields.io/github/license/vidurb/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/vidurb/docker-wireguard-transmission/blob/master/LICENSE)

[![Docker](https://img.shields.io/badge/docker-blue?style=flat&color=grey&logo=docker)](https://hub.docker.com/r/vidurb/wireguard-transmission)
![Docker Stars](https://img.shields.io/docker/stars/vidurb/wireguard-transmission?style=flat&color=blue&logo=docker&label=stars)
![Docker Pulls](https://img.shields.io/docker/pulls/vidurb/wireguard-transmission?style=flat&color=blue&logo=docker&label=pulls)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/vidurb/wireguard-transmission?style=flat&color=blue&logo=docker&label=build)

This is a fork of SebDanielsson's [image](https://github.com/SebDanielsson/docker-wireguard-transmission) that adds some features with help from Haugene's [OpenVPN+Transmission image](https://github.com/haugene/docker-transmission-openvpn).

Additions:
- Added S6 overlay
- Added generation of the Transmission settings file from environment variables as used in Haugene's image.
- Run transmission as a non-root user by default and let the user specify the UID and GID (this is why I forked)
- Multiarch builds using GitHub Actions

Additional environment variables:

| Variable  | Default | Description |
| ------------- | ------------- | ------------- |
| GLOBAL_APPLY_PERMISSIONS  | true  | ... |
| TRANSMISSION_ALT_SPEED_DOWN  | 50  | ... |
| TRANSMISSION_ALT_SPEED_ENABLED  | false  | ... |
| TRANSMISSION_ALT_SPEED_TIME_BEGIN  | 540  | ... |
| TRANSMISSION_ALT_SPEED_TIME_DAY  | 127  | ... |
| TRANSMISSION_ALT_SPEED_TIME_ENABLED  | false  | ... |
| TRANSMISSION_ALT_SPEED_TIME_END  | 1020  | ... |
| TRANSMISSION_ALT_SPEED_UP  | 50  | ... |
| TRANSMISSION_BIND_ADDRESS_IPV4  | 0.0.0.0  | ... |
| TRANSMISSION_BIND_ADDRESS_IPV6  | ::  | ... |
| TRANSMISSION_BLOCKLIST_ENABLED  | false  | ... |
| TRANSMISSION_BLOCKLIST_URL  | http://www.example.com/blocklist  | ... |
| TRANSMISSION_CACHE_SIZE_MB  | 4  | ... |
| TRANSMISSION_DHT_ENABLED  | true  | ... |
| TRANSMISSION_DOWNLOAD_DIR  | /data/completed  | ... |
| TRANSMISSION_DOWNLOAD_LIMIT  | 100  | ... |
| TRANSMISSION_DOWNLOAD_LIMIT_ENABLED  | 0  | ... |
| TRANSMISSION_DOWNLOAD_QUEUE_ENABLED  | true  | ... |
| TRANSMISSION_DOWNLOAD_QUEUE_SIZE  | 5  | ... |
| TRANSMISSION_ENCRYPTION  | 1  | ... |
| TRANSMISSION_IDLE_SEEDING_LIMIT  | 30  | ... |
| TRANSMISSION_IDLE_SEEDING_LIMIT_ENABLED  | false  | ... |
| TRANSMISSION_INCOMPLETE_DIR  | /data/incomplete  | ... |
| TRANSMISSION_INCOMPLETE_DIR_ENABLED  | true  | ... |
| TRANSMISSION_LPD_ENABLED  | false  | ... |
| TRANSMISSION_MAX_PEERS_GLOBAL  | 200  | ... |
| TRANSMISSION_MESSAGE_LEVEL  | 2  | ... |
| TRANSMISSION_PEER_CONGESTION_ALGORITHM  | none  | ... |
| TRANSMISSION_PEER_ID_TTL_HOURS  | 6  | ... |
| TRANSMISSION_PEER_LIMIT_GLOBAL  | 200  | ... |
| TRANSMISSION_PEER_LIMIT_PER_TORRENT  | 50  | ... |
| TRANSMISSION_PEER_PORT  | 51413  | ... |
| TRANSMISSION_PEER_PORT_RANDOM_HIGH  | 65535  | ... |
| TRANSMISSION_PEER_PORT_RANDOM_LOW  | 49152  | ... |
| TRANSMISSION_PEER_PORT_RANDOM_ON_START  | false  | ... |
| TRANSMISSION_PEER_SOCKET_TOS  | default  | ... |
| TRANSMISSION_PEX_ENABLED  | true  | ... |
| TRANSMISSION_PORT_FORWARDING_ENABLED  | false  | ... |
| TRANSMISSION_PREALLOCATION  | 1  | ... |
| TRANSMISSION_PREFETCH_ENABLED  | 1  | ... |
| TRANSMISSION_QUEUE_STALLED_ENABLED  | true  | ... |
| TRANSMISSION_QUEUE_STALLED_MINUTES  | 30  | ... |
| TRANSMISSION_RATIO_LIMIT  | 2  | ... |
| TRANSMISSION_RATIO_LIMIT_ENABLED  | false  | ... |
| TRANSMISSION_RENAME_PARTIAL_FILES  | true  | ... |
| TRANSMISSION_RPC_AUTHENTICATION_REQUIRED  | false  | ... |
| TRANSMISSION_RPC_BIND_ADDRESS  | 0.0.0.0  | ... |
| TRANSMISSION_RPC_ENABLED  | true  | ... |
| TRANSMISSION_RPC_HOST_WHITELIST  | none  | ... |
| TRANSMISSION_RPC_HOST_WHITELIST_ENABLED  | false  | ... |
| TRANSMISSION_RPC_PASSWORD  | password  | ... |
| TRANSMISSION_RPC_PORT  | 9091  | ... |
| TRANSMISSION_RPC_URL  | /transmission/  | ... |
| TRANSMISSION_RPC_USERNAME  | username  | ... |
| TRANSMISSION_RPC_WHITELIST  | 127.0.0.1  | ... |
| TRANSMISSION_RPC_WHITELIST_ENABLED  | false  | ... |
| TRANSMISSION_SCRAPE_PAUSED_TORRENTS_ENABLED  | true  | ... |
| TRANSMISSION_SCRIPT_TORRENT_DONE_ENABLED  | false  | ... |
| TRANSMISSION_SCRIPT_TORRENT_DONE_FILENAME  | none  | ... |
| TRANSMISSION_SEED_QUEUE_ENABLED  | false  | ... |
| TRANSMISSION_SEED_QUEUE_SIZE  | 10  | ... |
| TRANSMISSION_SPEED_LIMIT_DOWN  | 100  | ... |
| TRANSMISSION_SPEED_LIMIT_DOWN_ENABLED  | false  | ... |
| TRANSMISSION_SPEED_LIMIT_UP  | 100  | ... |
| TRANSMISSION_SPEED_LIMIT_UP_ENABLED  | false  | ... |
| TRANSMISSION_START_ADDED_TORRENTS  | true  | ... |
| TRANSMISSION_TRASH_ORIGINAL_TORRENT_FILES  | false  | ... |
| TRANSMISSION_UMASK  | 2  | ... |
| TRANSMISSION_UPLOAD_LIMIT  | 100  | ... |
| TRANSMISSION_UPLOAD_LIMIT_ENABLED  | 0  | ... |
| TRANSMISSION_UPLOAD_SLOTS_PER_TORRENT  | 14  | ... |
| TRANSMISSION_UTP_ENABLED  | false  | ... |
| TRANSMISSION_WATCH_DIR  | /data/watch  | ... |
| TRANSMISSION_WATCH_DIR_ENABLED  | true  | ... |
| TRANSMISSION_HOME  | /data/transmission-home  | ... |
| TRANSMISSION_WATCH_DIR_FORCE_GENERIC  | false  | ... |
| PUID  | none  | UID to run containerized process as |
| PGID  | none  | GID to run containerized process as |
| OVERWRITE_CONFIGURATION  | none  | Overwrite Transmission's configuration file if it already exists |


# Original README from SebDanielsson/docker-wireguard-transmission
Docker image for running Transmission over a WireGuard connection, based on Alpine Linux.

[![GitHub](https://img.shields.io/badge/github-blue?style=flat&color=grey&logo=GitHub)](https://github.com/SebDanielsson/docker-wireguard-transmission)
[![GitHub stars](https://img.shields.io/github/stars/SebDanielsson/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/SebDanielsson/docker-wireguard-transmission/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/SebDanielsson/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/SebDanielsson/docker-wireguard-transmission/issues)
[![GitHub forks](https://img.shields.io/github/forks/SebDanielsson/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/SebDanielsson/docker-wireguard-transmission/network)
[![GitHub license](https://img.shields.io/github/license/SebDanielsson/docker-wireguard-transmission?style=flat&color=blue&logo=github)](https://github.com/SebDanielsson/docker-wireguard-transmission/blob/master/LICENSE)

[![Docker](https://img.shields.io/badge/docker-blue?style=flat&color=grey&logo=docker)](https://hub.docker.com/r/sebdanielsson/wireguard-transmission)
![Docker Stars](https://img.shields.io/docker/stars/sebdanielsson/wireguard-transmission?style=flat&color=blue&logo=docker&label=stars)
![Docker Pulls](https://img.shields.io/docker/pulls/sebdanielsson/wireguard-transmission?style=flat&color=blue&logo=docker&label=pulls)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/sebdanielsson/wireguard-transmission?style=flat&color=blue&logo=docker&label=build)

## Changelog
**2020-06-01:** First release, most notable change since initial upload is the addition of two environemnt variables *INTERFACE* and *KILLSWITCH*. Read more about these in the usage section below.

## Usage
* **KILLSWITCH** let's you bind Transmission to only use the assigned VPN IP. If you don't want to use it you only need to leave the environment variable empty.
* **INTERFACE** let's you customize which WireGuard config file that wg-quick will load. Default: wg0 which loads /etc/wireguard/wg0.conf via the choosen mount volume. (See: *-v /path/to/wg-conf-dir*)

### docker run
```
docker run --name wireguard-transmission \
--privileged \
-e "USERNAME=transmission" \
-e "PASSWORD=transmission" \
-e "INTERFACE=wg0" \
-e "KILLSWITCH=wg0" \
-p 51820:51820/udp \
-p 9091:9091 \
-v /path/to/wg-conf-dir:/etc/wireguard \
-v /path/to/transmission-conf-dir:/etc/transmission-daemon \
-v /path/to/transmission-complete-dir:/transmission/complete \
-v /path/to/transmission-incomplete-dir:/transmission/incomplete \
-v /path/to/transmission-watch-dir:/transmission/watch \
sebdanielsson/wireguard-transmission
```

### docker-compose.yml
```
version: '3.7'
services:
    wireguard-transmission:
        container_name: wireguard-transmission
        privileged: true
        environment:
            - USERNAME=transmission
            - PASSWORD=transmission
            - INTERFACE=wg0
            - KILLSWITCH=wg0
        ports:
            - '51820:51820/udp'
            - '9091:9091'
        volumes:
            - '/path/to/wg-conf-dir:/etc/wireguard'
            - '/path/to/transmission-conf-dir:/etc/transmission-daemon'
            - '/path/to/transmission-complete-dir:/transmission/complete'
            - '/path/to/transmission-incomplete-dir:/transmission/incomplete'
            - '/path/to/transmission-watch-dir:/transmission/watch'
        image: sebdanielsson/wireguard-transmission
```

## To-Do
- [x] Configure Transmission kill switch dynamically on container creation
- [ ] Add multi arch support once Docker Hub automated builds supports it properly

## Donate
<a href="https://buymeacoffee.com/danielsson" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/white_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## Contribute
All contributions are appreciated

## License
MIT
