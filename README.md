# docker-wireguard-transmission
Docker image for running Transmission over a WireGuard connection, based on Alpine Linux

## Usage

### docker run
```
docker run --name wireguard-transmission \
--privileged \
-e "USERNAME=transmission" \
-e "PASSWORD=transmission" \
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
version: '3.3'
services:
    wireguard-transmission:
        container_name: wireguard-transmission
        privileged: true
        environment:
            - USERNAME=transmission
            - PASSWORD=transmission
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
* Configure Transmission kill switch dynamically on container creation
* Add multi arch support once Docker Hub automated builds supports it properly
* Feel free to request features

## Contribute
All contributions are appreciated

## License
MIT
