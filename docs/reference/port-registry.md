# Port Registry Guide

This guide covers the centralized port registry system in Niflheim, which provides a single source of truth for all service port allocations.

## Overview

The port registry (`modules/niflheim/ports.nix`) defines all service ports in one centralized location. This prevents port conflicts, provides clear documentation of port allocations, and makes it easy to see which ports are in use across the entire system.

### Benefits

- **Single source of truth** - All port allocations in one file
- **Prevents conflicts** - Easy to see which ports are taken
- **Type-safe references** - Compile-time validation of port usage
- **Centralized documentation** - Know where every service listens
- **Easy updates** - Change port in one place, updates everywhere

### When to Use

Use the port registry for:
- Network service ports (HTTP, databases, APIs)
- Monitoring exporters
- Media services
- Application web interfaces

Don't use for:
- Well-known system ports that never change (e.g., SSH 22)
- Ephemeral/dynamic ports
- Ports that are implementation details

## Structure

The port registry is organized into logical categories:

```nix
# modules/niflheim/ports.nix
_: {
  flake.niflheim.ports = {
    # Infrastructure (22, 80, 443, 53)
    ssh = 22;
    http = 80;
    https = 443;
    dns = 53;

    # Monitoring (3xxx, 9xxx)
    prometheus = 9090;
    grafana = 3000;
    loki = 3100;
    promtail = 9080;

    # Exporters (9xxx series)
    exporters = {
      node = 9100;
      nginx = 9113;
      zfs = 9134;
      cadvisor = 9338;
      smartctl = 9633;
    };

    # Media services (5xxx-9xxx)
    media = {
      jellyfin = 8096;
      jellyseerr = 5055;
      radarr = 7878;
      sonarr = 8989;
      # ...
    };

    # Applications (4xxx, 8xxx, 9xxx)
    blocky = 4000;
    vaultwarden = 8222;
    portainer = 9000;
    # ...
  };
}
```

### Categories

**Infrastructure** - Core system services (SSH, HTTP, DNS)

**Monitoring** - Observability stack (Prometheus, Grafana, Loki)

**Exporters** - Metrics exporters (nested under `exporters.*`)
- Convention: Use 9xxx series ports
- Standard Prometheus exporter ports when available

**Media** - Media server stack (nested under `media.*`)
- Jellyfin, *arr suite, download clients

**Applications** - Self-hosted applications
- Flat namespace for miscellaneous services

## Usage

Reference ports using `inputs.self.niflheim.ports.*`:

### Basic Usage

```nix
# modules/grafana.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana.settings.server.http_port = ports.grafana;
  };
}
```

### Nested Categories

```nix
# modules/jellyfin.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.media.jellyfin;
in {
  flake.modules.nixos.jellyfin = {
    services.jellyfin.port = port;
  };
}
```

### Multiple Ports

```nix
# modules/prometheus.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim.ports) prometheus exporters;
in {
  flake.modules.nixos.prometheus = {
    services.prometheus = {
      port = prometheus;
      exporters.node.port = exporters.node;
    };
  };
}
```

### With toString

Port values are integers. Use `toString` for string contexts:

```nix
# modules/grafana.nix
{ inputs, ... }: let
  ports = inputs.self.niflheim.ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana.provision.datasources.settings.datasources = [{
      url = "http://localhost:${toString ports.prometheus}";
    }];
  };
}
```

## Adding New Ports

### Step 1: Choose Port Number

Pick an appropriate port:
- Check existing allocations in `ports.nix`
- Follow category conventions:
  - Exporters: 9xxx series (match standard Prometheus ports)
  - Media: 5xxx-9xxx range
  - Applications: 4xxx, 8xxx, 9xxx ranges
- Avoid conflicts with well-known ports

### Step 2: Add to ports.nix

Add to appropriate category:

```nix
# modules/niflheim/ports.nix
_: {
  flake.niflheim.ports = {
    # ... existing ports

    # For standalone service
    myservice = 8888;

    # For nested category
    media = {
      # ... existing media ports
      myservice = 8888;
    };
  };
}
```

### Step 3: Reference in Module

Use the port in your service module:

```nix
# modules/myservice.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.myservice;
in {
  flake.modules.nixos.myservice = {
    services.myservice = {
      enable = true;
      inherit port;
    };
  };
}
```

### Step 4: Test

Verify the port is correctly referenced:

```bash
nix eval .#niflheim.ports.myservice  # Should output: 8888
nix flake check --impure  # Should pass without errors
```

## Migration Guide

### Converting Hardcoded Ports

**Before:**
```nix
# modules/jellyfin.nix - Hardcoded port
{
  services.jellyfin.port = 8096;
}
```

**After:**
```nix
# Step 1: Add to ports.nix
_: {
  flake.niflheim.ports.media.jellyfin = 8096;
}

# Step 2: Reference in module
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.media.jellyfin;
in {
  services.jellyfin.port = port;
}
```

### Converting Related Services

For services with multiple ports:

**Before:**
```nix
# modules/portainer.nix
{
  services.portainer = {
    httpPort = 9000;
    httpsPort = 9443;
    edgePort = 8000;
  };
}
```

**After:**
```nix
# Step 1: Add all ports to ports.nix
_: {
  flake.niflheim.ports = {
    portainer = 9000;
    portainerHTTPS = 9443;
    portainerEdge = 8000;
  };
}

# Step 2: Reference in module
{ inputs, ... }: let
  inherit (inputs.self.niflheim.ports) portainer portainerHTTPS portainerEdge;
in {
  services.portainer = {
    httpPort = portainer;
    httpsPort = portainerHTTPS;
    edgePort = portainerEdge;
  };
}
```

## Real-World Examples

### Grafana with Multiple Port References

```nix
# modules/grafana.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) server monitoring ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana = {
      enable = true;
      settings.server.http_port = ports.grafana;
      provision.datasources.settings.datasources = [
        {
          name = "Prometheus";
          url = "http://${monitoring.serverAddress}:${toString ports.prometheus}";
        }
        {
          name = "Loki";
          url = "http://${monitoring.serverAddress}:${toString ports.loki}";
        }
      ];
    };

    services.nginx.virtualHosts."grafana.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.grafana}";
      };
    };
  };
}
```

### Exporter with Registry

```nix
# modules/hosts/thor/node-exporter.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.exporters.node;
in {
  flake.modules.nixos.thor = {
    services.prometheus.exporters.node = {
      enable = true;
      inherit port;
    };
  };

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

### Media Service

```nix
# modules/jellyfin.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) server ports;
  port = ports.media.jellyfin;
in {
  flake.modules.nixos.jellyfin = {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.nginx.virtualHosts."jellyfin.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  };
}
```

## Best Practices

### Port Number Selection

- **Exporters:** Use standard Prometheus exporter ports (9xxx)
  - node-exporter: 9100
  - nginx-exporter: 9113
  - Check prometheus.io/docs for standard ports
- **Media services:** Use default application ports when possible
- **Applications:** Avoid conflicts with well-known services

### Naming Conventions

- **Simple services:** Lowercase service name (`grafana`, `jellyfin`)
- **Multi-port services:** Service name + purpose (`portainerHTTPS`, `transmissionPeer`)
- **Nested categories:** Use descriptive category names (`media.jellyfin`, `exporters.node`)

### Organization

- Group related services in nested categories
- Keep flat namespace for infrastructure services
- Document port ranges in comments
- Sort entries logically within categories

### Migration Strategy

1. Add new port to registry
2. Update service module to reference registry
3. Test that service still works
4. Remove hardcoded port value
5. Commit with clear message: `refactor(service): migrate to port registry`

## Troubleshooting

### Port Already in Use

**Error:** Service fails to start with "address already in use"

**Solution:**
1. Check `ports.nix` for conflicts
2. Verify no hardcoded ports in service config
3. Use `ss -tlnp | grep :PORT` to find conflicting service

### Type Errors

**Error:** "expected integer, got string"

**Solution:**
- Port values are integers, don't quote them
- Use `toString` when interpolating into strings

### Port Not Found

**Error:** "attribute 'myport' missing"

**Solution:**
1. Verify port added to `ports.nix`
2. Check spelling and category path
3. Run `nix eval .#niflheim.ports` to see all ports

## See Also

- [Architecture - Centralized Registry Pattern](architecture.md#rule-10-centralized-registry-pattern)
- [Monitoring Stack Guide](monitoring-stack.md)
- `modules/niflheim/ports.nix` - Port registry source
