# NixOS Server Configuration

> Aspect-oriented NixOS configuration following dendritic principles

Single-host server configuration built around
[**dendritic architecture**](https://github.com/mightyiam/dendritic) —
organizing modules by _what they do_ rather than _where they run_.

---

## Project Structure

```
modules/           # Aspect-oriented modules (auto-loaded by import-tree)
├── {aspect}.nix   # Single-purpose modules (ssh.nix, docker.nix)
├── {feature}/     # Multi-file features (nixvim/)
├── hosts/         # Host-specific configs
│   └── thor/      # Home server (NixOS)
├── media/         # Media stack (*arr apps, jellyfin)
├── settings/      # Project options (user.nix, ports.nix, server.nix)
└── lib/           # Helper functions

docs/              # Reference documentation (cheatsheets)
secrets/           # Encrypted secrets (agenix)
```

**Key Concepts:**

- **Dendritic/Aspect-Oriented**: Modules organized by _what they do_, not where they run
- **Auto-Loading**: `import-tree` loads all tracked `.nix` files automatically
- **Underscore Prefix**: Files like `_hardware.nix` require explicit import (safety for host-specific config)
- **Git Tracking Required**: Only git-tracked files are loaded by import-tree

---

## Host: thor

Home server running NixOS. Services:

### Media

| Name | Description |
|------|-------------|
| Jellyfin | Media server |
| Jellyseerr | Media request management |
| Sonarr | TV show management |
| Radarr | Movie management |
| Lidarr | Music management |
| Prowlarr | Indexer management |
| Bazarr | Subtitle management |
| Transmission | BitTorrent client |
| Sabnzbd | Usenet client |

### Monitoring

| Name | Description |
|------|-------------|
| Grafana | Metrics visualization |
| Prometheus | Time-series metrics database |
| Loki | Log aggregation |
| Promtail | Log shipping agent |
| Node Exporter | System metrics |
| Nginx Exporter | Web server metrics |
| ZFS Exporter | Filesystem metrics |
| cAdvisor | Container metrics |
| Smartctl Exporter | Disk health metrics |

### Infrastructure & Applications

| Name | Description |
|------|-------------|
| Nginx | Reverse proxy |
| Blocky | DNS server with ad-blocking |
| Tailscale | Mesh VPN |
| Docker | Container runtime |
| Portainer | Container management UI |
| Vaultwarden | Password manager |
| Karakeep | Bookmarking |
| Mealie | Recipe manager |
| Stirling-PDF | PDF toolkit |
| n8n | Workflow automation |
| ntfy | Push notifications |
| Uptime Kuma | Status monitoring |
| Immich | Photo management |
| Code Server | Browser-based VS Code |

---

## Quick Start

```bash
# Clone
git clone git@github.com:edrobertsrayne/nix-config.git
cd nix-config

# Deploy
sudo nixos-rebuild switch --flake .#thor

# Deploy from remote
nixos-rebuild switch --flake github:edrobertsrayne/nix-config#thor \
  --target-host thor --use-remote-sudo
```

---

## Documentation

- [Neovim Cheatsheet](docs/NEOVIM_CHEATSHEET.md)
- [Tmux Cheatsheet](docs/TMUX_CHEATSHEET.md)
- [CLAUDE.md](CLAUDE.md) - AI agent workflow guidelines

---

## Credits

- [dendrix](https://github.com/vic/dendrix) - Dendritic architecture
- [mightyiam/dendritic](https://github.com/mightyiam/dendritic) - Reference implementation
- [mightyiam/infra](https://github.com/mightyiam/infra) - Personal infra example
- [drupol/infra](https://github.com/drupol/infra) - Another dendritic example
