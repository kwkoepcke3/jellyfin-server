#!/usr/bin/env bash
set -euo pipefail

RUNTIME_USER="${RUNTIME_USER:-$USER}"
QUADLET_DIR="$HOME/.config/containers/systemd"
SERVICE_HOME="$HOME/mayo-server/subserv/jellyfin"


mkdir -p \
    "$QUADLET_DIR" \
    "$SERVICE_HOME/runtime/jellyfin/config" \
    "$SERVICE_HOME/runtime/sonarr/config" \
    "$SERVICE_HOME/runtime/radarr/config"

if [[ ! -d "/var/mnt/jellyfin" ]]; then
    sudo mkdir -p "/var/mnt/jellyfin"
    sudo chown "$RUNTIME_USER:$RUNTIME_USER" "/var/mnt/jellyfin"
fi

podman unshare chown -R 1000:1000 "$SERVICE_HOME/runtime/jellyfin"
podman unshare chown -R 1000:1000 "$SERVICE_HOME/runtime/sonarr"
podman unshare chown -R 1000:1000 "$SERVICE_HOME/runtime/radarr"
podman unshare chown -R 1000:1000 "/var/mnt/jellyfin"

ln -sf "$SERVICE_HOME/jellyfin.container" "$QUADLET_DIR/jellyfin.container"
ln -sf "$SERVICE_HOME/sonarr.container" "$QUADLET_DIR/sonarr.container"
ln -sf "$SERVICE_HOME/radarr.container" "$QUADLET_DIR/radarr.container"

systemctl --user daemon-reload

systemctl --user restart jellyfin.service sonarr.service radarr.service
