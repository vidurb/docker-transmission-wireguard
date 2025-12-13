# docker-transmission-wireguard

A Docker container running Transmission behind a WireGuard VPN.

## Features

- Runs Transmission and WireGuard in a single container.
- Based on Alpine Linux for a small image size.
- Uses OpenRC for service management.
- Transmission only starts after the WireGuard tunnel is up.

Available at [GitHub Container Registry](https://github.com/vidurb/docker-transmission-wireguard/pkgs/container/transmission-wireguard) and [Docker Hub](https://hub.docker.com/r/vidurb/transmission-wireguard).

## Usage

To use this Docker image, you can use the following `docker-compose.yml` file as a starting point:

```yaml
version: "3"
services:
  transmission-wireguard:
    image: ghcr.io/vidurb/transmission-wireguard
    container_name: transmission-wireguard
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    volumes:
      - ./wg0.conf:/etc/wireguard/wg0.conf
      - ./transmission:/var/lib/transmission/config
    ports:
      - "9091:9091"
    restart: unless-stopped
```

Alternatively, you can use `docker run` directly:

```bash
docker run -d \
  --name transmission-wireguard \
  --cap-add NET_ADMIN \
  --sysctl net.ipv4.conf.all.src_valid_mark=1 \
  -v ./wg0.conf:/etc/wireguard/wg0.conf \
  -v ./transmission:/var/lib/transmission/config \
  -p 9091:9091 \
  --restart unless-stopped \
  ghcr.io/vidurb/transmission-wireguard
```

Note that the image expects your WireGuard configuration file to be named wg0.conf and be in the `/etc/wireguard/` directory.

### Building the Image

To build the Docker image, run the following command in the root of the repository:

```bash
docker build -t <name of your choice> .
```

## Configuration

### WireGuard

Place your WireGuard configuration file (e.g., `wg0.conf`) in the `wireguard` directory. The container will automatically start the `wg-quick` service for the `wg0` interface.

### Transmission

The Transmission configuration files are located in the `transmission` directory. You can modify the `settings.json` file to customize your Transmission settings.

You can may modify the Transmission uid:gid using an entrypoint script:

```yaml
version: "3"
services:
  transmission-wireguard:
    image: ghcr.io/vidurb/transmission-wireguard
    ...
    entrypoint: /entrypoint.sh
    configs:
      - source: entrypoint
        target: /entrypoint.sh
        mode: 0555
configs:
  entrypoint:
    content: |
      addgroup -g 1000 tuser || true
      adduser -D -u 1000 -G tuser tuser || true
      echo 'command_user="tuser:tuser"' >> /etc/conf.d/transmission-daemon
      exec "$@"
```

## Ports

- `9091`: Transmission web UI
- `51413`: Transmission peer port (TCP)
- `51413/udp`: Transmission peer port (UDP)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
