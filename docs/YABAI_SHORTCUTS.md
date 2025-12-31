# Yabai + skhd Shortcuts - Niflheim Configuration

## Quick Reference Card

**Most Used Commands**:

```text
Cmd+Return          Open terminal
Cmd+Shift+B         Open browser
Cmd+Shift+E         Open file manager
Alt+H/J/K/L         Focus window (vi-style)
Cmd+Arrows          Focus window (arrow keys)
Cmd+Shift+Space     Toggle floating
Cmd+Ctrl+F          Fullscreen
Cmd+Shift+0         Balance windows
Cmd+Shift+R         Rotate layout
```

**Important Notes**:

- **CMD Key**: Primary modifier (Command key on macOS)
- **SIP Enabled**: Running in compatibility mode - basic tiling only
- **Vi Keys + Arrows**: Both styles supported for window navigation
- **No Workspace Control**: Use native macOS Spaces (Ctrl+Arrow)
- **Raycast Integration**: App launching via Raycast (leave Cmd+Space free)

---

## System Status

### Current Configuration: SIP Enabled

**What Works**:
- ✅ BSP tiling layout
- ✅ Window focus, swap, warp
- ✅ Window resizing
- ✅ Toggle float/fullscreen
- ✅ Layout rotation and mirroring
- ✅ Multi-display support
- ✅ Window rules (exclusions)
- ✅ Mouse support (Fn+drag)

**What Doesn't Work (Requires SIP Disabled)**:
- ❌ Create/destroy/focus workspaces
- ❌ Window opacity control
- ❌ Window animations
- ❌ Scratchpad windows
- ❌ Window layer control
- ❌ Sticky windows

**To Enable Full Features**:
1. Disable SIP in Recovery Mode
2. Set `services.yabai.enableScriptingAddition = true` in `yabai.nix`
3. Run: `sudo yabai --install-sa`
4. Restart yabai service

---

## Window Management

### Basic Operations

| Shortcut            | Action                              |
| ------------------- | ----------------------------------- |
| `Cmd+Shift+W`       | Close window                        |
| `Cmd+Shift+Space`   | Toggle floating (centered grid)     |
| `Cmd+Ctrl+F`        | Fullscreen (yabai zoom)             |
| `Cmd+Shift+F`       | Native fullscreen (macOS Mission)   |
| `Cmd+Shift+D`       | Toggle parent zoom                  |
| `Cmd+E`             | Toggle split direction              |

**Note**: Avoid using `Cmd+W` (conflicts with native close tab) and `Cmd+Q` (quit app).

### Window Focus

**Vi-Style Keys** (Recommended):

| Shortcut  | Action       |
| --------- | ------------ |
| `Alt+H`   | Focus left   |
| `Alt+J`   | Focus down   |
| `Alt+K`   | Focus up     |
| `Alt+L`   | Focus right  |

**Arrow Keys**:

| Shortcut        | Action       |
| --------------- | ------------ |
| `Cmd+Left`      | Focus left   |
| `Cmd+Down`      | Focus down   |
| `Cmd+Up`        | Focus up     |
| `Cmd+Right`     | Focus right  |

**Window Cycling**:

| Shortcut        | Action                  |
| --------------- | ----------------------- |
| `Alt+Tab`       | Next window             |
| `Alt+Shift+Tab` | Previous window         |

**Note**: Native macOS `Cmd+Tab` switches between apps, `Alt+Tab` (via yabai) switches between windows.

### Window Swap

**Vi-Style Keys**:

| Shortcut        | Action      |
| --------------- | ----------- |
| `Cmd+Shift+H`   | Swap left   |
| `Cmd+Shift+J`   | Swap down   |
| `Cmd+Shift+K`   | Swap up     |
| `Cmd+Shift+L`   | Swap right  |

**Arrow Keys**:

| Shortcut            | Action      |
| ------------------- | ----------- |
| `Cmd+Shift+Left`    | Swap left   |
| `Cmd+Shift+Down`    | Swap down   |
| `Cmd+Shift+Up`      | Swap up     |
| `Cmd+Shift+Right`   | Swap right  |

**Note**: Swap exchanges positions with adjacent window.

### Window Warp

**Vi-Style Keys**:

| Shortcut        | Action      |
| --------------- | ----------- |
| `Cmd+Ctrl+H`    | Warp left   |
| `Cmd+Ctrl+J`    | Warp down   |
| `Cmd+Ctrl+K`    | Warp up     |
| `Cmd+Ctrl+L`    | Warp right  |

**Arrow Keys**:

| Shortcut            | Action      |
| ------------------- | ----------- |
| `Cmd+Ctrl+Left`     | Warp left   |
| `Cmd+Ctrl+Down`     | Warp down   |
| `Cmd+Ctrl+Up`       | Warp up     |
| `Cmd+Ctrl+Ctrl+Right` | Warp right  |

**Note**: Warp moves window and re-inserts it in BSP tree structure.

### Window Resize

**Vi-Style Keys**:

| Shortcut      | Action                       |
| ------------- | ---------------------------- |
| `Cmd+Alt+H`   | Resize left (-50px)          |
| `Cmd+Alt+J`   | Resize down (+50px)          |
| `Cmd+Alt+K`   | Resize up (-50px)            |
| `Cmd+Alt+L`   | Resize right (+50px)         |

**Arrow Keys**:

| Shortcut          | Action              |
| ----------------- | ------------------- |
| `Cmd+Alt+Left`    | Resize left         |
| `Cmd+Alt+Down`    | Resize down         |
| `Cmd+Alt+Up`      | Resize up           |
| `Cmd+Alt+Right`   | Resize right        |

**Note**: Each resize operation changes dimensions by 50 pixels. Automatically falls back to opposite edge if primary direction fails.

---

## Layout Actions

### Layout Manipulation

| Shortcut            | Action                            |
| ------------------- | --------------------------------- |
| `Cmd+Shift+R`       | Rotate tree 90° clockwise         |
| `Cmd+Shift+Alt+R`   | Rotate tree 270° counter-clockwise|
| `Cmd+Shift+X`       | Mirror tree on x-axis (horizontal)|
| `Cmd+Shift+Y`       | Mirror tree on y-axis (vertical)  |
| `Cmd+Shift+0`       | Balance windows (equalize sizes)  |
| `Cmd+Shift+T`       | Toggle layout (BSP ↔ Float)       |

**Layout Modes**:
- **BSP** (Binary Space Partitioning): Automatic tiling layout
- **Float**: Floating windows (manual positioning)

---

## Multi-Display Support

### Focus Display

| Shortcut              | Action                 |
| --------------------- | ---------------------- |
| `Cmd+Alt+Ctrl+Left`   | Focus display west     |
| `Cmd+Alt+Ctrl+Right`  | Focus display east     |
| `Cmd+Alt+1`           | Focus display 1        |
| `Cmd+Alt+2`           | Focus display 2        |
| `Cmd+Alt+3`           | Focus display 3        |

### Move Window to Display

| Shortcut                | Action                          |
| ----------------------- | ------------------------------- |
| `Cmd+Shift+Alt+Left`    | Send to display west & follow   |
| `Cmd+Shift+Alt+Right`   | Send to display east & follow   |
| `Cmd+Shift+Alt+1`       | Send to display 1 & follow      |
| `Cmd+Shift+Alt+2`       | Send to display 2 & follow      |
| `Cmd+Shift+Alt+3`       | Send to display 3 & follow      |

**Note**: Moving to display automatically follows focus to that display.

---

## Workspace Navigation (Native macOS Spaces)

**Important**: yabai cannot create/destroy/focus workspaces with SIP enabled. Use native macOS Mission Control.

### Configure in System Settings

1. Open **System Settings** → **Keyboard** → **Shortcuts** → **Mission Control**
2. Enable shortcuts for:
   - Move left/right a space: `Ctrl+Left/Right`
   - Switch to Desktop 1-9: `Ctrl+1-9`

### Recommended Bindings

| Shortcut        | Action (via Mission Control)  |
| --------------- | ----------------------------- |
| `Ctrl+Left`     | Previous workspace/space      |
| `Ctrl+Right`    | Next workspace/space          |
| `Ctrl+1-9`      | Jump to workspace 1-9         |

**Note**: These are **native macOS shortcuts**, not configured in skhd. yabai will respect window placement on native Spaces.

---

## Applications

### Launch Applications

| Shortcut        | Action                      |
| --------------- | --------------------------- |
| `Cmd+Return`    | Open terminal (WezTerm)     |
| `Cmd+Shift+B`   | Open browser (Chrome)       |
| `Cmd+Shift+E`   | Open file manager (Finder)  |

**Note**:
- Raycast handles app launching (default: `Cmd+Space` or double-tap Option)
- No additional launcher keybinds needed - Raycast is the launcher
- Applications open in tiled mode by default (unless excluded)

### System Actions

| Shortcut            | Action                          |
| ------------------- | ------------------------------- |
| `Cmd+Shift+Alt+R`   | Restart yabai service           |

**Note**: Useful after config changes. Restarts yabai without logging out.

---

## Mouse Bindings

| Shortcut            | Action               |
| ------------------- | -------------------- |
| `Fn+Left Click`     | Move window (drag)   |
| `Fn+Right Click`    | Resize window (drag) |

**Focus Behavior**:
- **Focus follows mouse**: Enabled (autoraise mode)
- **Mouse follows focus**: Disabled (cursor stays put when using keyboard navigation)

**Note**: Using `Fn` key instead of `Cmd` avoids conflicts with native macOS shortcuts.

---

## Window Rules & Exclusions

### System Applications (Never Tiled)

The following apps are excluded from yabai window management:

**System Utilities**:
- System Settings / System Preferences
- Finder
- Activity Monitor
- Calculator
- App Store
- Archive Utility
- Installer
- Software Update

**User Applications**:
- Raycast (launcher)
- Alfred (if installed)
- Tailscale
- 1Password / Bitwarden
- Docker Desktop
- Adobe Creative Cloud
- UTM / VirtualBox

**Generic Patterns**:
- File dialogs (Open/Save/Choose)
- Preferences/Settings windows
- Picture-in-Picture windows
- Install/Update dialogs

### Optional Media App Exclusions

Commented out by default in `window-rules.nix`:
- VLC
- IINA
- QuickTime Player

**To exclude media apps**: Uncomment the relevant lines in `modules/darwin/yabai/window-rules.nix`.

---

## Gaps & Padding

**Current Settings** (configured in `appearance.nix`):

- **Window gap**: 12px (space between windows)
- **Padding**: 12px all sides (space from screen edges)
- **Split ratio**: 50/50 (new windows split evenly)
- **Auto-balance**: Off (manual balance via `Cmd+Shift+0`)

**To Adjust**: Edit `modules/darwin/yabai/appearance.nix`:

```nix
window_gap = 12;
top_padding = 12;
bottom_padding = 12;
left_padding = 12;
right_padding = 12;
```

---

## Tips & Tricks

1. **Both Key Styles Work**: Use vi keys (`hjkl`) or arrow keys - whatever feels natural
2. **Learn Vi Keys**: Alt+H/J/K/L for focus keeps hands on home row
3. **Balance Often**: Use `Cmd+Shift+0` to reset window sizes after manual resizing
4. **Rotate for Layout**: `Cmd+Shift+R` rotates the entire tree - useful for portrait displays
5. **Mirror for Swap**: `Cmd+Shift+X/Y` flips entire layout - faster than individual swaps
6. **Use Native Spaces**: Don't fight Mission Control - embrace macOS Spaces for workspace switching
7. **Raycast Integration**: Let Raycast handle app launching, keep yabai for window management only
8. **Restart Shortcut**: `Cmd+Shift+Alt+R` restarts yabai - memorize this for config testing

---

## Keyboard Layout Philosophy

**Design Principles**:

1. **Vi-First, Arrows Optional**: Vi keys (`hjkl`) as primary, arrows as fallback
2. **Modifier Consistency**:
   - `Alt` = Focus (read-only actions)
   - `Cmd+Shift` = Swap/Move (modify layout)
   - `Cmd+Ctrl` = Warp (advanced movement)
   - `Cmd+Alt` = Resize (adjust dimensions)
3. **Avoid Conflicts**: Don't override essential macOS shortcuts:
   - `Cmd+W` = Close tab (not yabai close window)
   - `Cmd+Q` = Quit app (keep native)
   - `Cmd+Tab` = App switcher (keep native)
   - `Cmd+Space` = Raycast/Spotlight (keep native)
4. **Symmetry**: Same keys work with both vi and arrow styles where possible

---

## Comparison: Hyprland vs Yabai

### Feature Parity

| Feature                | Hyprland | Yabai (SIP) |
| ---------------------- | -------- | ----------- |
| BSP/Dwindle Tiling     | ✅       | ✅          |
| Window Focus/Swap      | ✅       | ✅          |
| Window Resize          | ✅       | ✅          |
| Multi-Display          | ✅       | ✅          |
| Layout Rotation        | ✅       | ✅          |
| Window Rules           | ✅       | ✅          |
| Gaps & Padding         | ✅       | ✅          |
| Mouse Control          | ✅       | ✅          |
| Workspace Switching    | ✅       | ❌ (native) |
| Window Groups/Stacks   | ✅       | ❌          |
| Window Opacity         | ✅       | ❌          |
| Window Animations      | ✅       | ❌          |
| Custom Window Borders  | ✅       | ❌          |

### Key Differences

**Hyprland**:
- Full workspace control (create/destroy/focus)
- Window grouping (tabbed containers)
- Advanced visual effects (blur, shadows, animations)
- Wayland-native (Linux only)

**Yabai**:
- Relies on macOS Spaces for workspaces
- Simpler feature set with SIP enabled
- Better macOS integration (Raycast, native apps)
- Works alongside macOS window management

---

## Configuration Location

**Config managed via**:

- `modules/darwin/yabai/yabai.nix` - Main service configuration
- `modules/darwin/yabai/skhd.nix` - Keyboard shortcuts
- `modules/darwin/yabai/appearance.nix` - Gaps, padding, mouse behavior
- `modules/darwin/yabai/window-rules.nix` - App exclusions

**Actual config directories**:
- yabai: `~/.config/yabai/`
- skhd: `~/.config/skhd/`

**Logs** (if configured):
- skhd errors: `~/Library/Logs/skhd/skhd.err.log`
- skhd output: `~/Library/Logs/skhd/skhd.out.log`

---

## Troubleshooting

### Common Issues

**yabai not tiling windows**:
1. Check if app is excluded in `window-rules.nix`
2. Try toggling float: `Cmd+Shift+Space`
3. Check layout mode: `Cmd+Shift+T` to toggle BSP/float
4. Restart yabai: `Cmd+Shift+Alt+R`

**skhd shortcuts not working**:
1. Verify skhd is running: `launchctl list | grep skhd`
2. Check for keybind conflicts with other apps
3. Review error log: `~/Library/Logs/skhd/skhd.err.log`
4. Restart skhd: `launchctl kickstart -k "gui/${UID}/org.nixos.skhd"`

**Window focus not following mouse**:
- Check `appearance.nix`: `focus_follows_mouse = "autoraise"`
- Restart yabai after config changes

**Finder/System Settings getting tiled**:
- Verify window rules are loaded: `yabai -m rule --list`
- Check app name matches: `yabai -m query --windows | jq`

### Enable Debug Mode

```bash
# Restart yabai with debug logging
launchctl kickstart -k "gui/${UID}/org.nixos.yabai"

# Check yabai log
tail -f /tmp/yabai_$(whoami).out.log

# Check skhd log
tail -f ~/Library/Logs/skhd/skhd.out.log
```

---

## Additional Resources

- **yabai Wiki**: <https://github.com/koekeishiya/yabai/wiki>
- **skhd GitHub**: <https://github.com/koekeishiya/skhd>
- **macOS Spaces Guide**: <https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/>
- **SIP Guide**: <https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection>
- **Raycast**: <https://www.raycast.com>
- **Project Documentation**: See `CLAUDE.md for workflow and development guidelines

---

## Future Enhancements

**If you disable SIP**, you can enable:

1. **Workspace control** - Create, destroy, focus spaces programmatically
2. **Window opacity** - Transparent/translucent windows
3. **Window animations** - Smooth transitions
4. **Advanced borders** - Custom window borders with colors
5. **Sticky windows** - Windows that appear on all spaces
6. **Layer control** - Pin windows above/below others

**To enable**: Set `services.yabai.enableScriptingAddition = true` in `yabai.nix` and follow the SIP disabling guide.

---

**Last Updated**: 2025-11-15
**Configuration Version**: Niflheim - feat/yabai-skhd branch
**Mirrored From**: Hyprland configuration (modules/hyprland/)
