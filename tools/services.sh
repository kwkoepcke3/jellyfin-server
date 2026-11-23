#!/usr/bin/env bash
set -euo pipefail

RUNTIME_USER="${RUNTIME_USER:-$USER}"
QUADLET_DIR="$HOME/.config/containers/systemd"
SERVICE_HOME="$HOME/mayo-server/subserv/jellyfin"


mkdir -p "$QUADLET_DIR" 

if [[ ! -d "/var/mnt/jellyfin" ]]; then
    sudo mkdir -p "/var/mnt/jellyfin"
    sudo chown "$RUNTIME_USER:$RUNTIME_USER" "/var/mnt/jellyfin"
fi

podman unshare chown -R 1000:1000 "/var/mnt/jellyfin"

for container in $SERVICE_HOME/*.container; do
    SUBSERV=$(basename $container .container)

    mkdir -p "$SERVICE_HOME/runtime/$SUBSERV/config"
    podman unshare chown -R 1000:1000 "$SERVICE_HOME/runtime/$SUBSERV"

    ln -sf "$SERVICE_HOME/$SUBSERV.container" "$QUADLET_DIR/$SUBSERV.container"
done

systemctl --user daemon-reload

systemctl --user restart jellyfin.service sonarr.service radarr.service bazarr.service seerr.service usenet.service
