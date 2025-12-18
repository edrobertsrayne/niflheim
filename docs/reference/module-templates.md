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

## Summary: Choosing the Right Template

| Use Case | Template | Location |
|----------|----------|----------|
| Simple aspect (SSH, Git) | Basic Module | `modules/{aspect}.nix` |
| Feature with system + user config | Multi-Context | `modules/{feature}.nix` |
| Shared settings/options | Custom Options | `modules/niflheim/{option}.nix` |
| Group related features | Aggregator | `modules/{group}.nix` |
| Reusable functions | Helper Function | `modules/lib/{helper}.nix` |
| Complex feature | Complex Feature | `modules/{feature}/` |
| Desktop environment components | Namespace Extension | `modules/hyprland/{component}.nix` |
| Hardware/host-unique | Host-Specific | `modules/hosts/{hostname}/` |

## Tips

1. **Start simple** - Use Basic Module template, expand as needed
2. **One aspect per file** - Don't combine unrelated features
3. **Name by purpose** - File name describes what it configures, not how
4. **Follow existing patterns** - Look at similar modules in the codebase
5. **Remember git add** - New files must be tracked for import-tree to load them
6. **Use namespace extension** - For tightly-coupled components (like desktop environment), extend shared namespace
