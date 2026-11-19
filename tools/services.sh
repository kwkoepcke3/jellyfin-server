#!/usr/bin/env bash
set -euo pipefail

QUADLET_DIR="$HOME/.config/containers/systemd"
JELLYFIN_DIR="$HOME/jellyfin"

if [[ ! -d $QUADLET_DIR ]]; then
    mkdir -p $QUADLET_DIR
fi

ln -s $JELLYFIN_DIR/jellyfin.container $QUADLET_DIR/jellyfin.container

systemctl --user daemon-reload

systemctl --user start jellyfin.service
