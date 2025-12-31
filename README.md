# ❄️ Niflheim

> A beautiful, aspect-oriented NixOS configuration following dendritic
> principles

Niflheim is a complete NixOS configuration built around
[**dendritic architecture**](https://github.com/mightyiam/dendritic) —
organizing modules by _what they do_ rather than _where they run_. The result is
a highly modular, composable, and maintainable system that embraces
keyboard-first workflows and aesthetic design.

---

## 📋 Overview

This configuration represents a ground-up rewrite focusing on:

- **Aspect-Oriented Architecture**: Modules organized by purpose (desktop,
  development, media, system)
- **Automatic Module Loading**: Zero-maintenance imports via `import-tree`
- **Composable Design**: Mix and match aspects to build systems declaratively
- **Keyboard-First Workflow**: Everything accessible via keyboard (inspired by
  omarchy)
- **Unified Theming**: Material Design 3 theming via matugen (wallpaper-based)
- **Self-Documenting**: Clear module boundaries with explicit dependencies

---

## 💻 Current Hosts

| Host      | Type    | Status     | Description                                            |
| --------- | ------- | ---------- | ------------------------------------------------------ |
| **freya** | Desktop | ✅ Active  | Main development workstation with Hyprland             |
| **thor**  | Server  | ✅ Active  | Media server with monitoring and self-hosted services  |
| **imac**  | Desktop | ✅ Active  | macOS workstation with Yabai window manager            |
| **loki**  | Server  | 🗑️ Retired | Decommissioned                                         |

---

## ✨ Features

### 🖥️ Desktop Environment

- **Hyprland** compositor with comprehensive window management
- **Interactive menu system** (Super+Alt+Space) with organized access to common tasks
- **Screenshot tools** - grimblast + satty for capture and annotation
- **Material Design 3 theming** - matugen for dynamic color generation from wallpaper
- **Walker** application launcher (Super+Space)
- **Waybar** status bar with system information
- **SwayNC** notification daemon
- **Custom launchers** - launch-editor, launch-terminal, launch-browser, launch-presentation-terminal
- **SwayOSD** for volume and brightness feedback

### 🛠️ Development Tools

- **Neovim** with modular configuration powered by snacks.nvim and LazyVim-inspired plugins
- **Tmux** with vim-tmux-navigator integration
- **CLI utilities**: bat, eza, fzf, delta, lazygit, lazydocker, zoxide
- **Python**: uv for fast package management, ruff for linting, nix-ld for binary compatibility
- **JavaScript/TypeScript**: Bun runtime and package manager
- **Terminal emulators**: Ghostty (default), Alacritty, Wezterm
- **nh** - Nix helper for flake operations and system cleanup
- **Dev shells** for project-specific environments

### 🏗️ Infrastructure

- **Centralized Port Registry** - Single source of truth for all service ports
- **Automatic Module Loading** - Zero-maintenance imports via import-tree
- **Aspect-Oriented Architecture** - Modules organized by purpose, not host
- **NFS/Samba** network file sharing
- **Tailscale** mesh VPN
- **Cloudflare Tunnel** secure external access
- **Docker** container runtime

---

## 🚀 Services

### Freya (Desktop)

| Icon | Name | Description | Category |
|------|------|-------------|----------|
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/firefox.svg" width="32"/> | Firefox | Privacy-focused web browser | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/chromium.svg" width="32"/> | Chromium | Open-source web browser | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/obsidian.svg" width="32"/> | Obsidian | Knowledge base and note-taking | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/spotify.svg" width="32"/> | Spotify | Music streaming | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/vscodium.svg" width="32"/> | VSCodium | Open-source code editor | Development |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/steam.svg" width="32"/> | Steam | Gaming platform | Gaming |

### Thor (Server)

| Icon | Name | Description | Category |
|------|------|-------------|----------|
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/jellyfin.svg" width="32"/> | Jellyfin | Media server | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/jellyseerr.svg" width="32"/> | Jellyseerr | Media request management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/sonarr.svg" width="32"/> | Sonarr | TV show management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/radarr.svg" width="32"/> | Radarr | Movie management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/lidarr.svg" width="32"/> | Lidarr | Music management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prowlarr.svg" width="32"/> | Prowlarr | Indexer management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/bazarr.svg" width="32"/> | Bazarr | Subtitle management | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/transmission.svg" width="32"/> | Transmission | BitTorrent client | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/sabnzbd.svg" width="32"/> | Sabnzbd | Usenet client | Media |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg" width="32"/> | Grafana | Metrics visualization and dashboards | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | Prometheus | Time-series metrics database | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/loki.svg" width="32"/> | Loki | Log aggregation system | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/promtail.svg" width="32"/> | Promtail | Log shipping agent | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | Node Exporter | System metrics exporter | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | Nginx Exporter | Web server metrics exporter | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | ZFS Exporter | Filesystem metrics exporter | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | cAdvisor | Container metrics exporter | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/prometheus.svg" width="32"/> | Smartctl Exporter | Disk health metrics exporter | Monitoring |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/adguardhome.svg" width="32"/> | Blocky | DNS server with ad-blocking | Infrastructure |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/nginx.svg" width="32"/> | Nginx | Reverse proxy | Infrastructure |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/portainer.svg" width="32"/> | Portainer | Container management UI | Infrastructure |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/vaultwarden.svg" width="32"/> | Vaultwarden | Password manager | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/linkwarden.svg" width="32"/> | Karakeep | Self-hosted bookmarking | Application |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/svg/mealie.svg" width="32"/> | Mealie | Recipe manager | Application |

---

## 🙏 Influences & Credits

**Architecture & Configuration Management:**

- [dendrix](https://github.com/vic/dendrix) - Dendritic architecture principles
  for aspect-oriented NixOS configs
- [vix](https://github.com/vic/vix) - Reference implementation of dendritic
  patterns
- [mightyiam/dendritic](https://github.com/mightyiam/dendritic) - Reference
  dendritic implementation by the pattern author
- [mightyiam/infra](https://github.com/mightyiam/infra) - Personal
  infrastructure using dendritic
- [drupol/infra](https://github.com/drupol/infra) - Another infrastructure
  example using dendritic
- [GaetanLepage/nix-config](https://github.com/GaetanLepage/nix-config) - Modern
  NixOS configuration patterns

**Desktop & Design:**

- [omarchy](https://github.com/basecamp/omarchy) - Overall design philosophy,
  keyboard-first workflow, custom launcher scripts, and aesthetic approach
- [matugen](https://github.com/InioX/matugen) - Material Design 3 color scheme
  generator from wallpaper
- [Material Design 3](https://m3.material.io/) - Modern, accessible color system
  and design language

---

## 🚀 Quick Start

### Prerequisites

- NixOS with flakes enabled
- Git configured with SSH access to this repository

### Clone & Build

```bash
# Clone the repository
git clone git@github.com:edrobertsrayne/niflheim.git
cd niflheim

# Build a specific host configuration
sudo nixos-rebuild switch --flake .#freya  # Desktop
sudo nixos-rebuild switch --flake .#thor   # Server
```

### Deploy from Remote

```bash
# Build and deploy to a remote host
nixos-rebuild switch --flake github:edrobertsrayne/niflheim#thor \
  --target-host thor --use-remote-sudo
```

---

## 📚 Documentation

### Quick References

- [Hyprland Shortcuts](docs/HYPRLAND_SHORTCUTS.md) - Keyboard shortcuts for
  window management, menu system, and screenshots (Linux)
- [Yabai + skhd Shortcuts](docs/YABAI_SHORTCUTS.md) - Window manager shortcuts
  for macOS (SIP-compatible)
- [Ghostty Shortcuts](docs/GHOSTTY_SHORTCUTS.md) - Terminal emulator keyboard
  shortcuts and features
- [Neovim Cheatsheet](docs/NEOVIM_CHEATSHEET.md) - Editor shortcuts and features
- [Tmux Cheatsheet](docs/TMUX_CHEATSHEET.md) - Terminal multiplexer shortcuts

### AI Agent Guidelines

- [CLAUDE.md](CLAUDE.md) - Workflow and rules for AI-assisted development
