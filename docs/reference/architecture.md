# Niflheim Architecture Reference

This document provides detailed information about the Niflheim NixOS configuration architecture, module organization, and development patterns.

## Project Architecture

### Overview

- **Base:** Flake-parts with automatic module loading via `import-tree`
- **Pattern:** Aspect-oriented configuration (dendritic)
- **Organization:** Feature modules, aggregators, host-specific configs

### Directory Structure

```
niflheim/
├── flake.nix                    # Entry point (minimal, just dependencies)
├── modules/
│   ├── flake/                   # Flake-parts configuration
│   ├── niflheim/                # Custom project options (+user.nix)
│   ├── hosts/                   # Host-specific configurations
│   │   └── {hostname}/          # Per-host modules
│   ├── lib/                     # Custom library functions
│   ├── nixos/                   # NixOS-specific modules (networking, nix, ssh, etc.)
│   ├── darwin/                  # macOS-specific modules (darwin.nix, homebrew.nix, zsh.nix)
│   ├── desktop/                 # Desktop environment and GUI applications
│   │   ├── desktop.nix          # Platform-specific desktop aggregator
│   │   └── *.nix                # Desktop apps (alacritty, firefox, vscode, spotify, etc.)
│   ├── {feature}/               # Feature-specific modules (neovim/, hyprland/, waybar/, walker/)
│   └── {aspect}.nix             # Root-level aspect modules (audio.nix, starship.nix, zsh.nix, etc.)
└── secrets/                     # Secrets management
```

### Module Categories

1. **NixOS Modules:** `flake.modules.nixos.*` - System-level configuration
2. **Darwin Modules:** `flake.modules.darwin.*` - macOS system configuration
3. **Generic Modules:** `flake.modules.homeManager.*` - Cross-platform user configuration (home-manager)
4. **Flake Options:** `flake.niflheim.*` - Project-wide settings

### Key Concepts

- **Aspect Modules:** Each `.nix` file configures one aspect across multiple contexts
- **Aggregators:** Modules that import related features (e.g., `desktop.nix`)
- **No Manual Imports:** `import-tree` auto-loads modules; file location = documentation
- **Git-Tracked Files Only:** `import-tree` only loads files tracked by git - **always `git add` new files immediately**

---

## Import-Tree Behavior

This project uses `import-tree` for automatic module discovery. Understanding how it works is **critical** for successful development.

### How Import-Tree Works

`import-tree` automatically loads all `.nix` files from the `modules/` directory **that are tracked by git**. This means:

1. ✅ **Tracked files** (staged or committed) → Loaded by the flake
2. ❌ **Untracked files** (not added to git) → **Invisible to the flake**

### Required Workflow for New Files

**Every time you create a new `.nix` file, you MUST:**

```bash
# 1. Create the file (using Write tool)
# 2. IMMEDIATELY add it to git
git add modules/path/to/new-file.nix

# 3. NOW the flake can see it
nix flake check --impure  # Will work now
```

### Common Mistake

```bash
# ❌ WRONG - This will fail silently
Write modules/lib/helper.nix
# ... file created but not git-added
nix flake check  # ERROR: flake.lib defined multiple times
                 # (because import-tree didn't load helper.nix!)

# ✅ CORRECT
Write modules/lib/helper.nix
git add modules/lib/helper.nix
nix flake check  # SUCCESS - import-tree can now see the file
```

### Why This Matters

- `import-tree` uses git's index to discover files
- Untracked files are intentionally ignored (allows for drafts, backups with `_` prefix, etc.)
- **Symptom:** "file not found", "option defined multiple times", or missing functionality
- **Solution:** Always `git add` new files immediately after creation

### Files That Don't Need Git Add

- Files you're modifying (already tracked)
- Files prefixed with `_` (intentionally excluded)
- Non-`.nix` files (not loaded by import-tree)

---

## Development Rules

### Rule 1: Aspect-Oriented Naming

- ✓ Name files by **purpose/feature**, not implementation
- ✓ Examples: `ai-integration.nix`, `development-tools.nix`, `wayland-clipboard.nix`
- ✗ Avoid: `my-laptop.nix`, `package-list.nix`, `freya-specific.nix`

### Rule 2: Module Placement

Choose the right location:

| Type | Location | Example |
|------|----------|---------|
| Simple aspect | `modules/{name}.nix` | `modules/ssh.nix` |
| Complex feature | `modules/{feature}/` | `modules/neovim/lsp.nix` |
| Desktop environment | `modules/hyprland/` | `modules/hyprland/waybar/waybar.nix` |
| Host-specific | `modules/hosts/{hostname}/` | `modules/hosts/freya/hardware.nix` |
| Project option | `modules/niflheim/{name}.nix` | `modules/niflheim/user.nix` |
| Helper functions | `modules/lib/{name}.nix` | `modules/lib/nixvim.nix` |
| Cross-platform tools | `modules/{tool}.nix` | `modules/alacritty.nix`, `modules/python.nix` |
| macOS-specific | `modules/darwin/` | `modules/darwin/darwin.nix` |
| System-level config | `modules/nixos/` | `modules/nixos/networking.nix` |

### Rule 3: Aggregator Pattern

For related features commonly used together, you can create aggregator modules:
1. Create individual feature modules first
2. Optionally create an aggregator that imports them
3. Example: `utilities` aggregates CLI tools

```nix
# Good: aggregator for related tools
flake.modules.homeManager.utilities = {
  imports = with inputs.self.modules.homeManager; [
    git
    fzf
    bat
    eza
    delta
    lazygit
  ];
};
```

**Current approach:** Most hosts directly import individual modules rather than using aggregators, which provides maximum flexibility and clarity.

**Best Practice Example: Modular Feature Organization**

The `modules/neovim/` directory demonstrates excellent modular structure for complex features:

```
modules/neovim/
├── core.nix           # Core editor settings and options
├── keymaps.nix        # Keyboard shortcuts and bindings
├── lsp.nix            # Language server configuration
├── languages.nix      # Language-specific settings (Nix, Python, etc.)
├── telescope.nix      # Fuzzy finder configuration
├── git.nix            # Git integration (gitsigns)
├── terminal.nix       # Terminal integration (toggleterm, lazygit)
├── filetree.nix       # File explorer (NeoTree)
├── grug-far.nix       # Search and replace
├── tmux-navigator.nix # Vim-tmux navigation integration
├── diagnostics.nix    # Diagnostics and error display
├── ui.nix             # UI components
├── visuals.nix        # Visual enhancements
├── editor.nix         # Editor behavior
├── navigation.nix     # Navigation features
├── completion.nix     # Completion engine
├── treesitter.nix     # Syntax highlighting
└── mini.nix           # Mini.nvim suite
```

**Why this structure works well:**

1. **Single Responsibility:** Each file configures one specific aspect (LSP, git, telescope, etc.)
2. **Easy to Navigate:** Finding configuration is intuitive - LSP settings in `lsp.nix`, git in `git.nix`
3. **Self-Documenting:** File names clearly indicate what each module does
4. **Composable:** Features can be enabled/disabled independently
5. **Maintainable:** Changes to one feature don't affect others
6. **Scalable:** New features (like `grug-far.nix`) can be added without refactoring

**When to use this pattern:**

- Complex features with multiple sub-components (editor, compositor, media stack)
- When configuration for a single feature would exceed ~200 lines
- When different aspects have distinct concerns (keybindings vs. LSP vs. languages)
- When you want team members to easily find and modify specific functionality

**Contrast with anti-pattern:**

```nix
# ❌ BAD: monolithic file
modules/neovim.nix  # 2000+ lines of all neovim config

# ✅ GOOD: modular directory
modules/neovim/lsp.nix        # 150 lines focused on LSP
modules/neovim/keymaps.nix    # 150 lines focused on keybindings
modules/neovim/languages.nix  # 40 lines focused on language support
```

### Rule 4: Multi-Context Configuration

When a feature needs configuration at multiple levels:

**Shell configuration example:**
```nix
# System-level: modules/nixos/zsh.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.zsh = {pkgs, ...}: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;
  };
}

# User-level: modules/zsh.nix
_: {
  flake.modules.homeManager.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };
  };
}
```

**Host configuration example:**
```nix
# modules/hosts/freya/freya.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim.user) username;
in {
  # System-level imports
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      zsh
      greetd
      audio
      hyprland
      bluetooth
      gaming
    ];
  };

  # User-level imports
  flake.modules.homeManager.freya = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship
      utilities
      neovim
      obsidian
      spicetify
      python
    ];

    # Direct program configuration
    programs.firefox.enable = true;
    programs.vscode.enable = true;
  };
}
```

### Rule 5: Custom Options

Use `flake.niflheim.*` for project-wide settings:

```nix
# Define in modules/niflheim/+feature.nix or modules/niflheim/feature.nix
options.flake.niflheim.feature = {
  setting = lib.mkOption { ... };
};

# Reference in other modules
config.flake.modules.nixos.something = {
  value = config.flake.niflheim.feature.setting;
};
```

**Note:** The `+` prefix in filenames is optional - it's a convention to indicate custom options, but not required by import-tree.

### Rule 6: Hyprland Namespace Pattern

For desktop environment components, use the namespace extension pattern demonstrated in `modules/hyprland/`:

```nix
# modules/hyprland/waybar/waybar.nix
{ inputs, ... }: {
  # Extend the hyprland namespace via attribute merging
  flake.modules.homeManager.hyprland = {
    programs.waybar = {
      enable = true;
      settings = { /* ... */ };
    };
  };
}
```

**How it works:**
- Main module (`hyprland.nix`) defines `flake.modules.homeManager.hyprland`
- Related modules extend same namespace via attribute merging
- Import-tree auto-loads all files in the directory
- No manual imports needed in the aggregator

**Benefits:**
- All desktop components organized in one directory
- Clear namespace (`hyprland`) for all related functionality
- Automatic composition through import-tree
- Easy to find and modify desktop configuration

**When to use:**
- Desktop environments with multiple related components
- Feature sets that are always used together (compositor + bar + launcher + notifications)
- When you want directory structure to mirror functional grouping

**Example structure:**
```
modules/hyprland/
├── hyprland.nix          # Core module, defines namespace
├── waybar/waybar.nix     # Extends namespace
├── walker/walker.nix     # Extends namespace
├── swaync/swaync.nix     # Extends namespace
└── keybinds.nix          # Extends namespace
```

All modules extend `flake.modules.homeManager.hyprland`, creating unified configuration.

### Rule 7: Stylix Base Function Pattern

For platform-specific configuration with shared settings, use the base function pattern:

```nix
# modules/stylix.nix
{ inputs, ... }: let
  # Extract common configuration into a base function
  base = pkgs: {
    enable = true;
    base16Scheme = pkgs.lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
    opacity.terminal = 0.95;
    fonts.monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
  };
in {
  # NixOS-specific configuration
  flake.modules.nixos.stylix = {pkgs, ...}: {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = base pkgs // {
      # Linux-specific theming
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
    };
  };

  # Darwin-specific configuration
  flake.modules.darwin.stylix = {pkgs, ...}: {
    imports = [inputs.stylix.darwinModules.stylix];
    stylix = base pkgs;  # Uses base settings only
  };
}
```

**Benefits:**
- Shared settings defined once in the `base` function
- Platform-specific customizations added via attribute merging (`//`)
- Clear separation of common vs platform-specific configuration
- Easy to maintain and update shared settings

**When to use:**
- Platform-specific modules that share most configuration
- Theme/styling configuration that varies slightly by platform
- Any configuration where you want to avoid duplication

### Rule 8: Avoid Manual Imports

- ✗ DO NOT add imports in `flake.nix`
- ✓ DO let `import-tree` discover modules automatically
- ✓ DO use file organization as documentation
- ✓ DO `git add` new files immediately after creation

**IMPORTANT:** `import-tree` only discovers files that are tracked by git. After creating any new `.nix` file, you MUST run:
```bash
git add path/to/new-file.nix
```

Without `git add`, the new file will not be loaded by the flake, causing evaluation errors or missing functionality.

---

## Cross-Platform Architecture

Niflheim supports multiple platforms (NixOS, Darwin/macOS) through clear separation of platform-specific and cross-platform modules.

### Platform Categories

**Cross-Platform Modules** (`flake.modules.homeManager.*`) - Work on any platform:
- `modules/alacritty.nix` - Terminal emulator
- `modules/gtk.nix` - GTK theme configuration
- `modules/neovim/` - Editor configuration
- `modules/utilities/` - CLI tools aggregator
- `modules/obsidian.nix`, `modules/spicetify.nix`, `modules/python.nix` - Individual app configs
- User-level shell config (`modules/zsh.nix`, `modules/starship.nix`)

**Linux-Specific Modules** (`flake.modules.nixos.*` or `flake.modules.homeManager.*`):
- `modules/hyprland/` - Hyprland compositor with complete desktop environment
  - `hyprland.nix` - Core compositor configuration
  - `hypridle.nix`, `hyprlock.nix`, `hyprpaper.nix` - Hypr ecosystem tools
  - `waybar/` - Status bar
  - `walker/` - Application launcher
  - `swaync/` - Notification daemon
  - `swayosd.nix` - OSD for volume/brightness
  - `matugen/` - Material Design 3 theming
  - `xdg.nix` - XDG/MIME configuration
  - `keybinds.nix`, `window-rules.nix`, `appearance.nix` - Compositor configuration
  - `menu.nix`, `screenshot.nix`, `packages.nix` - Desktop utilities
- `modules/greetd.nix` - Display manager
- `modules/audio.nix` - Audio with pipewire
- `modules/gaming.nix` - Gaming support (Steam, etc.)
- `modules/nixos/` - NixOS system config (networking, nix, ssh, home-manager, user, locale, bluetooth, etc.)

**Darwin-Specific Modules** (`flake.modules.darwin.*`):
- `modules/darwin/darwin.nix` - macOS system defaults
- `modules/darwin/homebrew.nix` - Homebrew package management
- `modules/darwin/yabai/` - Yabai window manager with skhd keybinds
- System-level shell setup (`modules/darwin/zsh.nix`)

**Server Modules:** Many modules work on servers too:
- `modules/docker.nix` - Docker runtime
- `modules/nginx.nix` - Nginx reverse proxy
- `modules/blocky.nix` - DNS with ad-blocking
- `modules/home-assistant.nix` - Home automation
- `modules/portainer.nix` - Container management UI
- `modules/proxmox.nix` - Proxmox integration
- `modules/media/` - Media server stack (Jellyfin, *arr suite)
- Monitoring modules: `modules/node-exporter.nix`, `modules/smartd.nix`, `modules/zfs-exporter.nix`, etc.

### Design Principles

1. **Separation of Concerns:**
   - Simple cross-platform tools (Alacritty, GTK) are root-level modules
   - Complex apps (Firefox, VS Code, Chromium) configured directly in host files
   - Complete desktop environment (Hyprland) organized in `modules/hyprland/` directory
     - Includes compositor, Wayland tools (waybar, walker, swaync, swayosd), theming, and utilities
     - All extend `flake.modules.homeManager.hyprland` via attribute merging
   - Shell configuration split: system-level (`nixos.zsh`/`darwin.zsh`) and user-level (`homeManager.zsh`)

2. **Direct Host Composition:**
   - Home-manager enabled by default on all systems (nixos + darwin)
   - Hosts directly import individual modules for maximum clarity
   - Optional aggregators (like `utilities`) available for common groupings
   - No hidden magic - what you import is what you get

3. **Platform-Specific Packages:**
   - Helper scripts that depend on platform-specific tools defined in platform modules
   - Example: `modules/hyprland/packages.nix` contains launch-* scripts using Wayland tools

4. **Organized Module Structure:**
   - Single-file modules at root level follow aspect-oriented naming (`modules/audio.nix`, `modules/alacritty.nix`)
   - Complex features use directories (`modules/neovim/`, `modules/hyprland/`, `modules/media/`)
   - Platform-specific directories: `modules/nixos/`, `modules/darwin/`
   - Host-specific: `modules/hosts/{hostname}/`
   - Theme configuration uses `base` function pattern for shared settings

### Example: Multi-Platform Configuration

**Linux workstation (freya):**
```nix
# modules/hosts/freya/freya.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.freya = {
    imports = with inputs.self.modules.nixos; [
      zsh greetd audio hyprland bluetooth gaming
    ];
  };

  flake.modules.homeManager.freya = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship utilities neovim obsidian spicetify python
    ];

    programs.firefox.enable = true;
    programs.vscode.enable = true;
  };
}
```

**macOS workstation (odin):**
```nix
# modules/hosts/odin/odin.nix
{ inputs, ... }: {
  flake.modules.darwin.odin = {
    imports = with inputs.self.modules.darwin; [
      zsh yabai  # System-level macOS config
    ];
  };

  flake.modules.homeManager.odin = {
    imports = with inputs.self.modules.homeManager; [
      utilities zsh starship neovim  # Same cross-platform tools
    ];
  };
}
```

**Server (thor):**
```nix
# modules/hosts/thor/thor.nix
{ inputs, ... }: {
  flake.modules.nixos.thor = {
    imports = with inputs.self.modules.nixos; [
      zsh docker nginx blocky
    ];
  };

  flake.modules.homeManager.thor = {
    imports = with inputs.self.modules.homeManager; [
      utilities  # CLI tools only, no desktop apps
    ];
  };
}
```

### Benefits

- **Clear and explicit** - Host configs show exactly what's imported
- **No hidden magic** - Direct imports, no complex aggregator logic
- **Cross-platform consistency** - Same modules work on Linux and macOS
- **Platform-specific isolation** - Wayland/Hyprland deps stay in Linux modules
- **Flexible composition** - Mix and match modules as needed per host
- **Easy to understand** - One-to-one mapping between imports and functionality

---

## Resources

- **Dendritic Principles:** https://vic.github.io/dendrix/Dendritic.html
- **Flake Parts:** https://flake.parts
- **Reference Configs:**
  - https://github.com/vic/dendrix
  - https://github.com/mightyiam/dendritic - Reference dendritic implementation by the pattern author
  - https://github.com/mightyiam/infra - Personal infrastructure using dendritic
  - https://github.com/drupol/infra - Another infrastructure example using dendritic
  - https://github.com/GaetanLepage/nix-config
