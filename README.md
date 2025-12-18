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
- **Unified Theming**: System-wide consistency through Stylix (Tokyo Night)
- **Self-Documenting**: Clear module boundaries with explicit dependencies

---

## 💻 Current Hosts

| Host      | Type    | Status     | Description                                                    |
| --------- | ------- | ---------- | -------------------------------------------------------------- |
| **freya** | Desktop | ✅ Active  | Main development workstation with Hyprland                     |
| **thor**  | Server  | ✅ Active  | Media server with Jellyfin and *arr suite, Proxmox integration |
| **odin**  | Desktop | ✅ Active  | macOS workstation with Yabai window manager                    |
| **loki**  | Server  | 🗑️ Retired | Decommissioned                                                 |

---

## ✨ Features

### 🖥️ Desktop Environment

- **Hyprland** compositor with comprehensive window management
- **Interactive menu system** (Super+Alt+Space) with organized access to common
  tasks
- **Screenshot tools** - grimblast + satty for capture and annotation
- **Material Design 3 theming** - matugen for dynamic color generation with
  Ghostty integration
- **Walker** application launcher (Super+Space)
- **Waybar** status bar with system information
- **SwayNC** notification daemon
- **Custom launchers** - launch-editor, launch-terminal, launch-browser,
  launch-presentation-terminal
- **SwayOSD** for volume and brightness feedback

### 🛠️ Development Tools

- **Neovim** with modular configuration powered by snacks.nvim and
  LazyVim-inspired plugins
- **Tmux** with vim-tmux-navigator integration
- **CLI utilities**: bat, eza, fzf, delta, lazygit, lazydocker, zoxide
- **Python**: uv for fast package management, ruff for linting, nix-ld for binary
  compatibility
- **JavaScript/TypeScript**: Bun runtime and package manager
- **Terminal emulators**: Ghostty (default), Alacritty, Wezterm
- **nh** - Nix helper for flake operations and system cleanup
- **Dev shells** for project-specific environments

### 🎬 Media Server Stack

- **Jellyfin** media server
- **Jellyseerr** request management
- **Arr Suite**: Sonarr, Radarr, Lidarr, Prowlarr, Bazarr
- **Transmission** BitTorrent client
- **Sabnzbd** Usenet client

### 🏗️ Infrastructure

- **Home Assistant** home automation
- **Blocky** DNS server with ad-blocking
- **Nginx** reverse proxy for services
- **Proxmox** integration with monitoring
- **Portainer** container management
- **Karakeep** self-hosted bookmarking service
- **NFS/Samba** network file sharing
- **Tailscale** mesh VPN
- **Docker** container runtime
- **Monitoring** - node-exporter, smartd, zfs-exporter, unclean-boot-detector

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
- [stylix](https://github.com/danth/stylix) - System-wide theming engine
- [base16](https://github.com/tinted-theming/home/blob/main/styling.md) -
  Theming specification and color schemes

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

### Reference Documentation

- [Architecture](docs/reference/architecture.md) - Project structure and
  dendritic principles
- [Module Templates](docs/reference/module-templates.md) - Code templates for
  new modules
- [Anti-Patterns](docs/reference/anti-patterns.md) - Common mistakes to avoid
- [Commit Guide](docs/reference/commit-guide.md) - Conventional commits with
  examples
- [Troubleshooting](docs/reference/troubleshooting.md) - Error recovery and
  debugging

### AI Agent Guidelines

- [CLAUDE.md](CLAUDE.md) - Workflow and rules for AI-assisted development
