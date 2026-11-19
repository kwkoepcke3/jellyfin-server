```
h podman unshare chown -R 1000:1000 ~/jellyfin/runtime/jellyfin
h podman unshare chown -R 1000:1000 /var/mnt/jellyfin

echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/99-unprivileged-ports.conf
sudo sysctl --system

```

## Traefik
+ EMAIL
+ CF\_API\_TOKEN
