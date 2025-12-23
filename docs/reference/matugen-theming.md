# Matugen Theming Guide

This guide covers the Material Design 3 theming system using matugen in Niflheim, including how themes are generated, applied, and how to add new applications to the theming system.

## Overview

Matugen is a Material Design 3 color scheme generator that extracts a color palette from your wallpaper and generates consistent themes across all your applications.

### How It Works

1. **Color Extraction** - Matugen analyzes wallpaper image
2. **Palette Generation** - Creates MD3-compliant color palette
3. **Template Processing** - Applies colors to app-specific templates
4. **Theme Application** - Writes theme files to app config directories
5. **Reload Trigger** - Post-hooks reload apps to apply changes

### Benefits

- **Unified aesthetics** - All apps match wallpaper colors
- **Material Design 3** - Modern, accessible color system
- **Automatic updates** - Change wallpaper, themes update
- **Consistent UX** - Same colors across desktop environment

### Currently Themed Applications

- **Hyprland** - Compositor colors and window decorations
- **Waybar** - Status bar styling
- **SwayNC** - Notification center
- **Walker** - Application launcher
- **GTK3/GTK4** - System-wide GTK theme
- **Ghostty** - Terminal emulator
- **Cava** - Audio visualizer

## Configuration Structure

### Main Configuration

Location: `modules/hyprland/matugen/default.nix`

**Components:**
1. **Package** - Matugen binary from flake input
2. **Config file** - Template definitions and post-hooks
3. **Template files** - Color variable definitions

### Template Definition

Each app needs a template entry in `config.toml`:

```toml
[templates.appname]
input_path = '/path/to/template'
output_path = '/path/to/config'
post_hook = 'command to reload app'  # Optional
```

**Fields:**
- `input_path` - Template file location (in `~/.local/share/matugen/`)
- `output_path` - Generated config destination
- `post_hook` - Shell command to reload app after theme update

### Template Files

Template files use mustache syntax with color variables:

**Simple CSS template:**
```css
@define-color primary {{colors.primary.default.hex}};
@define-color on_primary {{colors.on_primary.default.hex}};
```

**Hyprland conf template:**
```
$primary = rgba({{colors.primary.default.hex_stripped}}ff)
$surface = rgba({{colors.surface.default.hex_stripped}}ff)
```

**Application-specific (ghostty):**
```
background = {{colors.surface.default.hex}}
foreground = {{colors.on_surface.default.hex}}
cursor-color = {{colors.on_surface.default.hex}}
```

## Color Variables

### Material Design 3 Color System

Matugen provides MD3 color roles accessible via `{{colors.role.default.hex}}`:

**Primary Colors:**
- `primary` - Primary brand color
- `on_primary` - Text/icons on primary color
- `primary_container` - Less prominent primary
- `on_primary_container` - Text/icons on primary container

**Secondary Colors:**
- `secondary` - Secondary brand color
- `on_secondary` - Text/icons on secondary
- `secondary_container` - Less prominent secondary
- `on_secondary_container` - Text/icons on secondary container

**Tertiary Colors:**
- `tertiary` - Accent color
- `on_tertiary` - Text/icons on tertiary
- `tertiary_container` - Less prominent tertiary
- `on_tertiary_container` - Text/icons on tertiary container

**Surface Colors:**
- `surface` - Background surfaces
- `on_surface` - Text/icons on surface
- `surface_variant` - Alternative surface
- `on_surface_variant` - Text/icons on surface variant
- `surface_dim` - Dimmed surface
- `surface_bright` - Bright surface
- `surface_container` - Container surface
- `surface_container_low` - Low-emphasis container
- `surface_container_high` - High-emphasis container
- `surface_container_highest` - Highest-emphasis container

**Utility Colors:**
- `error` - Error states
- `on_error` - Text/icons on error
- `error_container` - Error container
- `on_error_container` - Text/icons on error container
- `outline` - Borders and dividers
- `outline_variant` - Subtle borders

### Color Formats

Templates can access colors in different formats:

```
{{colors.primary.default.hex}}           # #7aa2f7
{{colors.primary.default.hex_stripped}}  # 7aa2f7
{{colors.primary.default.rgb}}           # rgb(122, 162, 247)
{{colors.primary.default.rgba}}          # rgba(122, 162, 247, 1.0)
```

## Adding New Applications

### Step 1: Create Template File

Create template in `modules/hyprland/matugen/`:

```nix
# modules/hyprland/matugen/myapp.mustache
background = {{colors.surface.default.hex}}
foreground = {{colors.on_surface.default.hex}}
accent = {{colors.primary.default.hex}}
```

### Step 2: Add Template to dataFile

Update `modules/hyprland/matugen/default.nix`:

```nix
xdg.dataFile = {
  # ... existing templates
  "matugen/myapp".text = builtins.readFile ./myapp.mustache;
};
```

### Step 3: Add Template Definition

Add to config.toml in same file:

```nix
xdg.configFile."matugen/config.toml".text = ''
  # ... existing templates

  [templates.myapp]
  input_path = '${config.xdg.dataHome}/matugen/myapp'
  output_path = '${config.xdg.configHome}/myapp/theme'
  post_hook = 'pkill -SIGUSR2 myapp'
'';
```

### Step 4: Reference Theme in App Config

Update app configuration to use generated theme:

```nix
# modules/myapp.nix
flake.modules.homeManager.myapp = {
  programs.myapp = {
    enable = true;
    theme = "matugen";  # Or include generated file
  };
}
```

### Step 5: Test

```bash
# Generate theme from current wallpaper
matugen image /path/to/wallpaper.png

# Verify output file created
cat ~/.config/myapp/theme

# Check app reloaded
ps aux | grep myapp
```

## Real-World Examples

### Ghostty Terminal

**Template file:** `modules/hyprland/matugen/ghostty.mustache`

```
palette = 0=#15161e
palette = 1=#f7768e
# ... more palette entries
background = {{colors.surface.default.hex}}
foreground = {{colors.on_surface.default.hex}}
cursor-color = {{colors.on_surface.default.hex}}
selection-background = {{colors.secondary_fixed_dim.default.hex}}
```

**Template definition:**

```toml
[templates.ghostty]
input_path = '~/.local/share/matugen/ghostty'
output_path = '~/.config/ghostty/themes/matugen'
post_hook = 'pkill -SIGUSR2 ghostty'
```

**App configuration:**

```nix
# modules/ghostty.nix
programs.ghostty.settings.theme = "matugen";
```

### Cava Audio Visualizer

**Template file:** `modules/hyprland/matugen/cava.mustache`

```
[color]
background = 'default'
foreground = '{{colors.primary.default.hex}}'

gradient = 1
gradient_color_1 = '{{colors.primary_container.default.hex}}'
gradient_color_2 = '{{colors.primary.default.hex}}'
gradient_color_3 = '{{colors.on_primary_container.default.hex}}'
```

**Template definition:**

```toml
[templates.cava]
input_path = '~/.local/share/matugen/cava'
output_path = '~/.config/cava/config'
post_hook = 'pkill -USR1 cava'
```

### CSS-Based Apps (Waybar, SwayNC, Walker)

**Template file:** `modules/hyprland/matugen/default.nix`

```nix
"matugen/colors.css".text = ''
  <* for name, value in colors *>
    @define-color {{name}} {{value.default.hex}};
  <* endfor *>
'';
```

**Template definitions:**

```toml
[templates.waybar]
input_path = '~/.local/share/matugen/colors.css'
output_path = '~/.config/waybar/colors.css'
post_hook = 'pkill -SIGUSR2 waybar'

[templates.swaync]
input_path = '~/.local/share/matugen/colors.css'
output_path = '~/.config/swaync/colors.css'

[templates.walker]
input_path = '~/.local/share/matugen/colors.css'
output_path = '~/.config/walker/themes/matugen/colors.css'
```

**App usage:**

```css
/* waybar style.css */
@import "colors.css";

window {
  background-color: @surface;
  color: @on_surface;
}

.module {
  background-color: @primary_container;
  color: @on_primary_container;
}
```

### Hyprland Compositor

**Template file:** `modules/hyprland/matugen/default.nix`

```nix
"matugen/hyprland.conf".text = ''
  <* for name, value in colors *>
  $image = {{image}}
  ''${{name}} = rgba({{value.default.hex_stripped}}ff)
  <* endfor *>
'';
```

**Template definition:**

```toml
[templates.hyprland]
input_path = '~/.local/share/matugen/hyprland.conf'
output_path = '~/.config/hypr/colors.conf'
post_hook = 'hyprctl reload'
```

**App usage:**

```nix
# modules/hyprland/appearance.nix
source = ./colors.conf

general {
  col.active_border = $primary $secondary 45deg
  col.inactive_border = $surface_variant
}

decoration {
  col.shadow = $shadow
}
```

## Template Syntax

### Mustache Basics

Matugen uses mustache templating:

**Variable interpolation:**
```
{{colors.primary.default.hex}}
```

**Iteration:**
```
<* for name, value in colors *>
  @define-color {{name}} {{value.default.hex}};
<* endfor *>
```

**Conditional:**
```
<* if dark_mode *>
  background = #000000
<* else *>
  background = #ffffff
<* endif *>
```

### Available Variables

- `{{image}}` - Path to wallpaper image
- `{{colors.ROLE.default.FORMAT}}` - Color values
- `{{dark_mode}}` - Boolean dark mode flag
- Custom variables can be passed to matugen CLI

## Post-Hooks

Post-hooks reload applications after theme changes.

### Common Reload Methods

**SIGUSR2 signal:**
```bash
pkill -SIGUSR2 waybar   # Reload waybar
pkill -SIGUSR2 ghostty  # Reload ghostty
```

**SIGUSR1 signal:**
```bash
pkill -USR1 cava  # Reload cava
```

**IPC reload:**
```bash
hyprctl reload  # Reload hyprland
```

**Full restart:**
```bash
systemctl --user restart myapp
```

### Post-Hook Best Practices

- Use signals when supported (non-disruptive)
- Avoid full restarts (lose state)
- Test hook works before adding
- Handle missing process gracefully (hook failures don't break generation)

## Usage Workflow

### Manual Theme Generation

```bash
# Generate from wallpaper
matugen image ~/wallpapers/current.png

# Generate from URL
matugen image https://example.com/wallpaper.jpg

# Dry run (preview without writing)
matugen image wallpaper.png --dry-run
```

### Automatic Theme Generation

Integrate with wallpaper changer:

```nix
# Example with hyprpaper
programs.hyprpaper = {
  settings = {
    preload = [ "/path/to/wallpaper.png" ];
    wallpaper = [ ",/path/to/wallpaper.png" ];
  };
};

# Add to window manager startup
exec-once = matugen image /path/to/wallpaper.png
```

### Theme Testing

```bash
# Preview generated colors
matugen image wallpaper.png --json | jq '.colors'

# Check specific output file
cat ~/.config/ghostty/themes/matugen

# Verify app reload
journalctl --user -u ghostty -f  # Watch app logs
```

## Customization

### Override Colors

Modify generated colors in templates:

```nix
"matugen/custom.css".text = ''
  /* Generated colors */
  <* for name, value in colors *>
    @define-color {{name}} {{value.default.hex}};
  <* endfor *>

  /* Custom overrides */
  @define-color custom_accent #ff00ff;
  @define-color custom_bg mix(@surface, @primary, 0.1);
'';
```

### Adjust Palette

Modify color extraction in template:

```
/* Lighten primary for better contrast */
primary = {{colors.primary.default.hex}}
primary_light = mix(@primary, #ffffff, 0.3)
```

### Per-App Customization

Different apps can use different color roles:

```
/* Terminal - high contrast */
background = {{colors.surface.default.hex}}
foreground = {{colors.on_surface.default.hex}}

/* Status bar - subtle */
background = {{colors.surface_container.default.hex}}
foreground = {{colors.on_surface_variant.default.hex}}
```

## Troubleshooting

### Template Not Generating

**Symptoms:** Output file not created after running matugen

**Solutions:**
1. Check template path in config.toml
2. Verify input template exists: `ls ~/.local/share/matugen/`
3. Check matugen logs: `matugen image wallpaper.png --verbose`
4. Test template syntax with dry-run

### Post-Hook Failing

**Symptoms:** Theme generates but app doesn't reload

**Solutions:**
1. Test hook manually: `pkill -SIGUSR2 waybar`
2. Check app is running: `ps aux | grep waybar`
3. Review app reload mechanism (might need different signal)
4. Check app logs for reload confirmation

### Colors Not Applying

**Symptoms:** Theme file generated but colors wrong in app

**Solutions:**
1. Verify app reads generated file: Check app config includes/imports theme
2. Check color format matches app expectations (hex vs rgb vs rgba)
3. Test with static color: Replace `{{colors.primary}}` with `#ff0000`
4. Restart app instead of reload to clear cache

### Wrong Color Roles

**Symptoms:** Colors applied but aesthetics poor

**Solutions:**
- Use `surface` for backgrounds, not `primary`
- Use `on_*` variants for text on colored backgrounds
- Use `*_container` for less prominent elements
- Reference MD3 guidelines: https://m3.material.io/styles/color

### Path Errors

**Symptoms:** "File not found" errors in matugen

**Solutions:**
1. Use full paths in config.toml: `${config.xdg.configHome}`
2. Ensure directories exist before generation
3. Check template uses correct variable expansion
4. Verify no typos in path names

## Best Practices

### Color Role Selection

- **Backgrounds:** `surface`, `surface_container`, `surface_variant`
- **Text:** `on_surface`, `on_surface_variant`
- **Accents:** `primary`, `secondary`, `tertiary`
- **Interactive elements:** `primary_container`, `secondary_container`
- **Errors/warnings:** `error`, `error_container`
- **Borders:** `outline`, `outline_variant`

### Template Organization

- One template file per application
- Group similar apps (CSS apps share template)
- Use mustache includes for shared snippets
- Document color role choices in templates

### Post-Hook Strategy

- Prefer signals over restarts
- Test hooks don't fail on missing process
- Use `|| true` for non-critical hooks
- Document required signals in app module

### Maintenance

- Keep templates synchronized with app config changes
- Test theme generation after updating matugen
- Document custom color overrides
- Version template files with git

## See Also

- [Architecture - Hyprland Namespace Pattern](architecture.md#rule-6-hyprland-namespace-pattern)
- Material Design 3 Color System: https://m3.material.io/styles/color
- Matugen Documentation: https://github.com/InioX/matugen
- `modules/hyprland/matugen/` - Template source files
- `modules/ghostty.nix` - Example themed application
