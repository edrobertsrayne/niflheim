# Ghostty Shortcuts - Niflheim Configuration

## Quick Reference Card

**Most Used Commands**:

```text
Linux/Windows           macOS                   Action
─────────────────────────────────────────────────────────────
Ctrl+Shift+N            Cmd+N                   New window
Ctrl+Shift+T            Cmd+T                   New tab
Ctrl+Shift+O            Cmd+D                   Split right
Ctrl+Shift+E            Cmd+Shift+D             Split down
Ctrl+Shift+C            Cmd+C                   Copy
Ctrl+Shift+V            Cmd+V                   Paste
Shift+Insert            -                       Paste (custom)
Control+Insert          -                       Copy (custom)
Ctrl+Shift+W            Cmd+W                   Close tab
Ctrl++                  Cmd++                   Increase font
Ctrl+-                  Cmd+-                   Decrease font
Ctrl+,                  Cmd+,                   Open config
```

**Important Notes**:

- **Terminal Type**: Set to `xterm-256color` for compatibility
- **Custom Split Resizing**: `Super+Ctrl+Shift+Alt+Arrows` for 100px adjustments
- **Insert Key Clipboard**: Linux-style `Shift+Insert` paste and `Control+Insert` copy
- **No Close Confirmation**: `confirm-close-surface` disabled for quick workflow
- **Block Cursor**: Non-blinking block cursor enabled

---

## Custom Keybinds (Niflheim Config)

**From** `modules/ghostty.nix`:

### Clipboard Operations

| Shortcut | Action |
|----------|--------|
| `Shift+Insert` | Paste from clipboard (Linux-style) |
| `Control+Insert` | Copy to clipboard (Linux-style) |

### Split Resizing

| Shortcut | Action |
|----------|--------|
| `Super+Ctrl+Shift+Alt+Down` | Resize split down (100px) |
| `Super+Ctrl+Shift+Alt+Up` | Resize split up (100px) |
| `Super+Ctrl+Shift+Alt+Left` | Resize split left (100px) |
| `Super+Ctrl+Shift+Alt+Right` | Resize split right (100px) |

**Note**: Super key is Windows/Command key. These custom bindings provide precise split control beyond standard ghostty shortcuts.

---

## Window Management

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+N` | `Cmd+N` | New window |
| `Alt+F4` | `Cmd+Shift+W` | Close window |
| `Ctrl+Enter` | `Cmd+Enter` | Toggle fullscreen |
| `Ctrl+Shift+Q` | `Cmd+Q` | Quit application |

---

## Tab Management

### Tab Operations

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+T` | `Cmd+T` | New tab |
| `Ctrl+Shift+W` | `Cmd+W` | Close tab |
| `Ctrl+Tab` | `Cmd+Shift+]` | Next tab |
| `Ctrl+Shift+Tab` | `Cmd+Shift+[` | Previous tab |

### Direct Tab Navigation

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Alt+1` through `Alt+8` | `Cmd+1` through `Cmd+8` | Go to tab 1-8 |
| `Alt+9` | `Cmd+9` | Go to last tab |

---

## Split Management

### Creating Splits

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+O` | `Cmd+D` | New split (right) |
| `Ctrl+Shift+E` | `Cmd+Shift+D` | New split (down) |

### Navigating Splits

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Super+[` | `Cmd+[` | Focus previous split |
| `Ctrl+Super+]` | `Cmd+]` | Focus next split |

### Split Layout

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+Enter` | `Cmd+Shift+Enter` | Toggle split zoom (fullscreen) |
| `Ctrl+Super+Shift+=` | `Cmd+Ctrl+=` | Equalize splits |

### Resizing Splits (Custom)

| Shortcut | Action |
|----------|--------|
| `Super+Ctrl+Shift+Alt+Down` | Resize split down (100px) |
| `Super+Ctrl+Shift+Alt+Up` | Resize split up (100px) |
| `Super+Ctrl+Shift+Alt+Left` | Resize split left (100px) |
| `Super+Ctrl+Shift+Alt+Right` | Resize split right (100px) |

**Note**: Custom resize bindings provide precise control with larger increments than default.

---

## Copy & Paste

### Standard Clipboard

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+C` | `Cmd+C` | Copy to clipboard |
| `Ctrl+Shift+V` | `Cmd+V` | Paste from clipboard |

### Custom Clipboard (Linux)

| Shortcut | Action |
|----------|--------|
| `Shift+Insert` | Paste from clipboard (custom) |
| `Control+Insert` | Copy to clipboard (custom) |

**Note**: Insert-based shortcuts provide traditional Linux terminal clipboard workflow.

---

## Text Navigation

### Scrollback

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Shift+Home` | `Cmd+Home` | Scroll to top |
| `Shift+End` | `Cmd+End` | Scroll to bottom |

### Prompt Navigation

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+Shift+Page Up` | `Cmd+Up` | Jump to previous prompt |
| `Ctrl+Shift+Page Down` | `Cmd+Down` | Jump to next prompt |

### Clear Screen

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| - | `Cmd+K` | Clear screen (macOS only) |

---

## Font Size

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl++` | `Cmd++` | Increase font size |
| `Ctrl+-` | `Cmd+-` | Decrease font size |
| `Ctrl+0` | `Cmd+0` | Reset font size |

---

## Configuration & Tools

| Linux/Windows | macOS | Action |
|---------------|-------|--------|
| `Ctrl+,` | `Cmd+,` | Open configuration |
| `Ctrl+Shift+,` | `Cmd+Shift+,` | Reload configuration |
| `Ctrl+Shift+I` | `Cmd+Option+I` | Toggle inspector |
| `Ctrl+Shift+J` | `Cmd+Shift+J` | Write scrollback to file |

**Features**:
- Inspector provides debugging and performance info
- Scrollback export saves terminal history to file
- Config reload applies changes without restart

---

## Tips & Tricks

1. **xterm-256color**: Terminal type set for broad compatibility with tmux, neovim, and CLI tools
2. **Custom Clipboard**: Linux Insert-based shortcuts work alongside standard Ctrl+Shift shortcuts
3. **Split Workflow**: Create splits with `Ctrl+Shift+O/E`, resize with custom Super shortcuts, zoom with `Ctrl+Shift+Enter`
4. **Tab Navigation**: Direct access to first 8 tabs via `Alt+1-8` (Linux) or `Cmd+1-8` (macOS)
5. **No Close Warnings**: `confirm-close-surface` disabled for faster workflow - be careful!
6. **Padding**: 14px window padding on both axes for clean appearance
7. **Cursor Style**: Block cursor without blinking for reduced distraction
8. **Prompt Jumping**: Use `Ctrl+Shift+Page Up/Down` to navigate command history visually
9. **All Shortcuts Customizable**: Keybinds configured via `keybind` list in ghostty settings
10. **GTK Integration**: Flat toolbar style on Linux for minimal window chrome

---

## Configuration Location

**Config managed via**: `modules/ghostty.nix`

**Actual config directory**: `~/.config/ghostty/`

**Key settings**:
- Terminal type: `xterm-256color`
- Window padding: 14px (x and y)
- Cursor: Block, non-blinking
- Close confirmation: Disabled
- Resize overlay: Never shown
- Custom keybinds: Insert clipboard ops, split resizing

**XDG Terminal Integration**: Ghostty set as default terminal via `xdg.terminal-exec` on Linux systems.

---

## Additional Resources

- **Ghostty Documentation**: Official documentation and keybind reference
- **Project Documentation**: See `CLAUDE.md for workflow guidelines
- **Related Shortcuts**:
  - `docs/TMUX_CHEATSHEET.md` - Terminal multiplexer inside ghostty
  - `docs/NEOVIM_CHEATSHEET.md` - Editor shortcuts
  - `docs/HYPRLAND_SHORTCUTS.md` - Window manager shortcuts
