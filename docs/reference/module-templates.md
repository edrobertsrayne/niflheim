# Module Templates

This document provides code templates for common module patterns in Niflheim configuration.

## Basic Module Template

The simplest module structure for a single aspect:

```nix
# modules/{aspect}.nix
{ inputs, config, lib, pkgs, ... }: {
  # NixOS system-level config (if needed)
  flake.modules.nixos.myAspect = {
    # System services, packages, configuration
    environment.systemPackages = [ pkgs.somePackage ];
    services.someService.enable = true;
  };

  # Home-Manager user-level config (if needed)
  flake.modules.homeManager.myAspect = {
    # User programs, dotfiles, configuration
    programs.someProgram.enable = true;
    home.packages = [ pkgs.somePackage ];
  };
}
```

**When to use:** Most aspect modules that need both system and user configuration.

---

## Multi-Context Configuration Template

When a feature needs extensive configuration in both contexts:

```nix
# modules/myfeature.nix
{ inputs, config, lib, pkgs, ... }: {
  flake.modules.nixos.myFeature = {
    # System-level: services, kernel modules, system packages
    services.myService = {
      enable = true;
      port = 8080;
      settings = {
        option1 = "value1";
      };
    };

    environment.systemPackages = with pkgs; [
      myfeature-cli
    ];

    # System-wide environment variables
    environment.variables = {
      MYFEATURE_HOME = "/var/lib/myfeature";
    };
  };

  flake.modules.homeManager.myFeature = {
    # User-level: programs, dotfiles, user packages
    programs.myfeature = {
      enable = true;
      settings = {
        theme = "dark";
        editor = "nvim";
      };
    };

    # User dotfiles
    home.file.".myfeaturerc".text = ''
      # Configuration file
      setting = value
    '';

    # User packages
    home.packages = with pkgs; [
      myfeature-extras
    ];
  };
}
```

**When to use:** Features that require both system services and user configuration.

---

## Custom Options Template

For project-wide settings that other modules need to reference:

```nix
# modules/niflheim/+myoption.nix
{ inputs, config, lib, ... }: {
  options.flake.niflheim.myOption = {
    enable = lib.mkEnableOption "My feature";

    setting = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = "A configurable setting for my feature";
    };

    complexSetting = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = { key1 = "value1"; key2 = "value2"; };
      description = "Complex structured setting";
    };
  };

  config.flake.niflheim.myOption = {
    # Default configuration can go here
    # Or leave empty and let host configs set values
  };
}
```

**Then reference in other modules:**

```nix
# modules/some-aspect.nix
{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.flake.niflheim.myOption;
in {
  flake.modules.nixos.someAspect = lib.mkIf cfg.enable {
    # Use the custom option values
    services.something.value = cfg.setting;
  };
}
```

**When to use:** Settings that need to be shared across multiple modules or configured per-host.

---

## Aggregator Pattern Template

For grouping related features together:

```nix
# modules/utilities/utilities.nix
{ inputs, ... }: {
  flake.modules.homeManager.utilities = {
    imports = with inputs.self.modules.homeManager; [
      # CLI tools
      git
      fzf
      bat
      eza
      delta
      lazygit
    ];
  };
}
```

**When to use:** Grouping related features that are commonly enabled together.

**Note:** Current architecture favors direct imports in hosts over aggregators for maximum clarity.

---

## Helper Function Template

For reusable library functions:

```nix
# modules/lib/myhelpers.nix
{ inputs, ... }: {
  flake.lib.myHelpers = {
    # Simple helper function
    mkSetting = value: {
      enable = true;
      setting = value;
    };

    # More complex helper
    mkModuleConfig = { name, package, settings ? {} }: {
      services.${name} = {
        enable = true;
        package = package;
      } // settings;
    };

    # Helper with multiple parameters
    mkKeybind = { key, command, description ? "" }: {
      inherit key command;
      desc = description;
    };
  };
}
```

**Then use in other modules:**

```nix
# modules/some-aspect.nix
{ inputs, config, lib, pkgs, ... }:
let
  helpers = inputs.self.lib.myHelpers;
in {
  flake.modules.nixos.someAspect = {
    services.myService = helpers.mkModuleConfig {
      name = "myService";
      package = pkgs.myPackage;
      settings = {
        port = 8080;
      };
    };
  };
}
```

**When to use:** Patterns that repeat across multiple modules.

---

## Conditional Configuration Template

For modules that should behave differently based on conditions:

```nix
# modules/development.nix
{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.flake.niflheim.development;
  isDevMachine = config.networking.hostName == "freya";
in {
  options.flake.niflheim.development = {
    languages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Development languages to support";
    };
  };

  flake.modules.nixos.development = {
    environment.systemPackages = with pkgs;
      # Base development tools
      [ git gh ]

      # Conditional packages based on languages
      ++ lib.optionals (lib.elem "rust" cfg.languages) [ rustc cargo ]
      ++ lib.optionals (lib.elem "python" cfg.languages) [ python3 ]
      ++ lib.optionals (lib.elem "nix" cfg.languages) [ nixd alejandra ]

      # Extra tools only on dev machines
      ++ lib.optionals isDevMachine [ gdb valgrind ];
  };
}
```

**When to use:** Configuration that varies based on host or user settings.

---

## Complex Feature Module Template

For features that need their own directory:

```nix
# modules/neovim/core.nix
{ inputs, ... }: {
  flake.modules.homeManager.neovim = {
    imports = [
      ./keymaps.nix
      ./lsp.nix
      ./languages.nix
      ./telescope.nix
    ];

    programs.nixvim.enable = true;
  };
}
```

```nix
# modules/neovim/keymaps.nix
{ inputs, ... }: {
  programs.nixvim = {
    keymaps = [
      # ... keybindings
    ];
  };
}
```

```nix
# modules/neovim/lsp.nix
{ inputs, ... }: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        # ... LSP servers
      };
    };
  };
}
```

**When to use:** Features with enough configuration to warrant multiple files.

---

## Namespace Extension Pattern Template

For desktop environment components that extend a shared namespace:

```nix
# modules/hyprland/waybar/waybar.nix
{ inputs, ... }: {
  # Extend the hyprland namespace via attribute merging
  flake.modules.homeManager.hyprland = {
    programs.waybar = {
      enable = true;
      settings = {
        # ... waybar configuration
      };
    };

    # Can also add packages, files, etc.
    home.packages = [ /* ... */ ];
  };
}
```

```nix
# modules/hyprland/walker/walker.nix
{ inputs, ... }: {
  # Also extends the hyprland namespace
  flake.modules.homeManager.hyprland = {
    programs.walker = {
      enable = true;
      # ... walker configuration
    };
  };
}
```

**How it works:**
- Main module (`hyprland.nix`) defines the namespace
- Related modules extend same namespace via attribute merging
- Import-tree auto-loads all files in directory
- No manual imports needed

**When to use:** Desktop environments or feature sets with multiple tightly-coupled components.

---

## Host-Specific Configuration Template

For truly host-specific config (hardware, unique settings):

```nix
# modules/hosts/freya/default.nix
{ inputs, config, lib, pkgs, modulesPath, ... }: {
  flake.modules.nixos.hosts.freya = {
    # Import hardware-specific modules
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware.nix
    ];

    # Host identity
    networking.hostName = "freya";

    # Host-specific overrides
    services.tailscale.enable = true;

    # Boot configuration
    boot.loader.systemd-boot.enable = true;
  };
}
```

```nix
# modules/hosts/freya/hardware.nix
{ config, lib, pkgs, ... }: {
  # Hardware-specific configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/...";
    fsType = "ext4";
  };

  hardware.cpu.intel.updateMicrocode = true;
}
```

**When to use:** Hardware config, hostname, and truly machine-specific settings.

---

## Centralized Registry Template

For shared configuration values referenced across multiple modules:

```nix
# modules/niflheim/ports.nix
_: {
  flake.niflheim.ports = {
    # Infrastructure ports
    ssh = 22;
    http = 80;
    https = 443;

    # Monitoring services
    prometheus = 9090;
    grafana = 3000;
    loki = 3100;

    # Exporters (nested category)
    exporters = {
      node = 9100;
      nginx = 9113;
      zfs = 9134;
    };

    # Media services (nested category)
    media = {
      jellyfin = 8096;
      sonarr = 8989;
      radarr = 7878;
    };
  };
}
```

**Then reference in service modules:**

```nix
# modules/grafana.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana.settings.server.http_port = ports.grafana;
  };
}

# modules/jellyfin.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.media.jellyfin;
in {
  flake.modules.nixos.jellyfin = {
    services.jellyfin.port = port;
  };
}
```

**When to use:**
- Service ports (prevent conflicts)
- Shared constants (domain names, IP addresses)
- Configuration values needed by multiple modules
- Values requiring system-wide consistency

**Benefits:**
- Single source of truth
- Type-safe references
- Easy to see all allocations
- Prevents conflicts and duplication

---

## Dual-Namespace Pattern Template

For distributed systems with central services and host-specific agents:

```nix
# modules/prometheus.nix - Central service
{ inputs, ... }: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.prometheus = {
    services.prometheus = {
      enable = true;
      port = ports.prometheus;
      # Scrape configs added by individual exporters
      scrapeConfigs = [];
    };
  };
}
```

```nix
# modules/grafana.nix - Central service
{ inputs, ... }: let
  inherit (inputs.self.niflheim) monitoring ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana = {
      enable = true;
      settings.server.http_port = ports.grafana;

      # Auto-configure datasources
      provision.datasources.settings.datasources = [{
        name = "Prometheus";
        url = "http://${monitoring.serverAddress}:${toString ports.prometheus}";
      }];
    };
  };
}
```

```nix
# modules/hosts/thor/node-exporter.nix - Host-specific agent
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.exporters.node;
in {
  # Configure local exporter
  flake.modules.nixos.thor = {
    services.prometheus.exporters.node = {
      enable = true;
      inherit port;
    };
  };

  # Register with central Prometheus (extends global config)
  flake.modules.nixos.prometheus = {
    services.prometheus.scrapeConfigs = [{
      job_name = "node-exporter";
      static_configs = [{
        targets = ["thor:${toString port}"];
      }];
    }];
  };
}
```

**When to use:**
- Monitoring infrastructure (Prometheus + exporters)
- Distributed logging (Loki + promtail)
- Load balancing (central LB + backend nodes)
- Any client-server architecture across hosts

**Benefits:**
- Clear separation: central vs distributed
- Host-specific agents only load on relevant hosts
- Central config automatically includes all agents
- Scalable - add agents without modifying central config

---

## Host-Level Service Extension Template

For host-specific services that extend global configurations:

```nix
# modules/hosts/thor/zfs-exporter.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.exporters.zfs;
in {
  # Define local service (thor-specific)
  flake.modules.nixos.thor = {
    services.prometheus.exporters.zfs = {
      enable = true;
      inherit port;
      # ZFS-specific configuration
    };
  };

  # Extend global Prometheus config (available everywhere)
  flake.modules.nixos.prometheus = {
    services.prometheus.scrapeConfigs = [{
      job_name = "zfs-exporter";
      static_configs = [{
        targets = ["thor:${toString port}"];
        labels.instance = "thor";
      }];
    }];
  };
}
```

```nix
# modules/hosts/thor/promtail.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) monitoring ports;
in {
  # Local log shipping agent
  flake.modules.nixos.thor = {
    services.promtail = {
      enable = true;
      configuration = {
        server.http_listen_port = ports.promtail;
        clients = [{
          url = "http://${monitoring.serverAddress}:${toString ports.loki}/loki/api/v1/push";
        }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            labels = { host = "thor"; };
          };
        }];
      };
    };
  };
}
```

**When to use:**
- Monitoring exporters (most common)
- Log shipping agents
- Backup agents registering with central server
- Service discovery for distributed systems

**Benefits:**
- Colocation - agent and registration in same file
- Self-contained - adding exporter auto-registers it
- No central bottleneck - don't modify root configs
- Each host manages its own agents

---

## Underscore Prefix Pattern Template

For host-specific modules that should not auto-load:

```nix
# modules/hosts/thor/_hardware.nix - Not auto-loaded
{ config, lib, pkgs, ... }: {
  # Host-specific hardware config
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/...";
    fsType = "ext4";
  };
}
```

```nix
# modules/hosts/thor/_nfs.nix - Network service with side effects
{ config, lib, pkgs, ... }: {
  services.nfs.server = {
    enable = true;
    exports = ''
      /export/media 192.168.1.0/24(rw,sync,no_subtree_check)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
```

```nix
# modules/hosts/thor/thor.nix - Explicit imports required
{ inputs, ... }: {
  flake.modules.nixos.thor = {
    imports = [
      ./_hardware.nix  # Must explicitly import
      ./_nfs.nix       # Must explicitly import
      ./_samba.nix     # Must explicitly import
    ];

    # Regular configuration
    networking.hostName = "thor";
  };
}
```

**When to use:**
- Host-specific config that breaks other hosts
- Modules with side effects (network services, ports)
- Hardware-specific settings
- Security-critical configuration
- Want explicit control over loading

**Benefits:**
- Safety - won't auto-load on wrong host
- Explicit - clear what's being imported
- Version control - tracked in git
- Opt-in loading via manual import

**Pattern creates visibility levels:**
1. **Public modules** (no prefix) - Auto-load everywhere
2. **Private modules** (`_` prefix) - Explicit import required
3. **Untracked files** (git ignored) - Local only

---

## Summary: Choosing the Right Template

| Use Case | Template | Location |
|----------|----------|----------|
| Simple aspect (SSH, Git) | Basic Module | `modules/{aspect}.nix` |
| Feature with system + user config | Multi-Context | `modules/{feature}.nix` |
| Shared settings/options | Custom Options | `modules/niflheim/{option}.nix` |
| Shared constants (ports, domains) | Centralized Registry | `modules/niflheim/ports.nix` |
| Group related features | Aggregator | `modules/{group}.nix` |
| Reusable functions | Helper Function | `modules/lib/{helper}.nix` |
| Complex feature | Complex Feature | `modules/{feature}/` |
| Desktop environment components | Namespace Extension | `modules/hyprland/{component}.nix` |
| Central service + distributed agents | Dual-Namespace | Root + `modules/hosts/{host}/` |
| Monitoring exporters | Host-Level Service Extension | `modules/hosts/{host}/{exporter}.nix` |
| Hardware/host-unique | Host-Specific | `modules/hosts/{hostname}/` |
| Host config with side effects | Underscore Prefix | `modules/hosts/{host}/_*.nix` |

## Tips

1. **Start simple** - Use Basic Module template, expand as needed
2. **One aspect per file** - Don't combine unrelated features
3. **Name by purpose** - File name describes what it configures, not how
4. **Follow existing patterns** - Look at similar modules in the codebase
5. **Remember git add** - New files must be tracked for import-tree to load them
6. **Use namespace extension** - For tightly-coupled components (like desktop environment), extend shared namespace
