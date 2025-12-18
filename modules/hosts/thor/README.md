# Thor Host Configuration

## File Organization

- `thor.nix` - Main host configuration (import this)
- `_*.nix` - Implementation modules (private to thor)
- Other `.nix` files - Auto-loaded by import-tree

## Underscore Prefix Convention

Files with `_` prefix are:
- Tracked in git (for version control)
- Excluded from automatic import-tree loading
- Manually imported by `thor.nix` for explicit dependencies
- Host-specific implementations not meant for reuse

### Current Private Modules

- `_hardware.nix` - Hardware configuration
- `_nfs.nix` - NFS server configuration
- `_samba.nix` - Samba file sharing
- `_proxmox.nix` - Proxmox VM settings
- `_monitoring.nix` - Monitoring stack

### Why Underscore Prefix?

Prevents:
- Accidental enabling of services on wrong hosts
- Import-tree loading sensitive configs automatically
- Security issues from auto-enabled network services

### Adding New Thor-Specific Config

1. Create `_feature.nix` (underscore prefix for safety)
2. Add explicit import in `thor.nix`:
   ```nix
   imports = [ ./_feature.nix ];
   ```
3. Git add immediately: `git add modules/hosts/thor/_feature.nix`

### Auto-Loaded Files

Files without `_` prefix (like `bridge.nix`, `disko.nix`) are auto-loaded by import-tree. Use this for config that's safe to always enable.
