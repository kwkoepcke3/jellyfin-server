#!/usr/bin/env bash
set -euo pipefail

RUNTIME_USER="${RUNTIME_USER:-$USER}"
QUADLET_DIR="$HOME/.config/containers/systemd"
JELLYFIN_DIR="$HOME/jellyfin"


mkdir -p \
    "$QUADLET_DIR" \
    "$JELLYFIN_DIR/data/traefik" \
    "$JELLYFIN_DIR/runtime/traefik/letsencrypt" \
    "$JELLYFIN_DIR/runtime/jellyfin"

if [[ ! -f "$JELLYFIN_DIR/runtime/traefik/letsencrypt/acme.json" ]]; then
    touch "$JELLYFIN_DIR/runtime/traefik/letsencrypt/acme.json"
    chmod 600 "$JELLYFIN_DIR/runtime/traefik/letsencrypt/acme.json"
fi

if [[ ! -d "/var/mnt/jellyfin" ]]; then
    sudo mkdir -p "/var/mnt/jellyfin"
    sudo chown "$RUNTIME_USER:$RUNTIME_USER" "/var/mnt/jellyfin"
fi

podman unshare chown -R 1000:1000 "$JELLYFIN_DIR/runtime/jellyfin"
podman unshare chown -R 1000:1000 "$JELLYFIN_DIR/runtime/sonarr"
podman unshare chown -R 1000:1000 "/var/mnt/jellyfin"

ln -sf "$JELLYFIN_DIR/jellyfin.container" "$QUADLET_DIR/jellyfin.container"
ln -sf "$JELLYFIN_DIR/jellyfin.network" "$QUADLET_DIR/jellyfin.network"
ln -sf "$JELLYFIN_DIR/traefik.container" "$QUADLET_DIR/traefik.container"
ln -sf "$JELLYFIN_DIR/sonarr.container" "$QUADLET_DIR/sonarr.container"

systemctl --user daemon-reload

systemctl --user restart traefik.service
systemctl --user restart jellyfin.service
