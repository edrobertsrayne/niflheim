# Monitoring Stack Guide

This guide covers the Grafana/Prometheus/Loki monitoring infrastructure in Niflheim, including how to add new exporters and configure monitoring for services.

## Overview

Niflheim uses a comprehensive monitoring stack for observability:

- **Grafana** - Metrics visualization and dashboards
- **Prometheus** - Time-series metrics database
- **Loki** - Log aggregation system
- **Promtail** - Log shipping agent
- **Exporters** - Metrics collection agents (node, nginx, zfs, cadvisor, smartctl)

### Architecture

The monitoring stack uses a **dual-namespace pattern**:

- **Central services** (root modules) - Grafana, Prometheus, Loki
- **Distributed agents** (host modules) - Exporters, Promtail

This allows:
- Central monitoring server on one host
- Distributed exporters on multiple hosts
- Automatic registration of exporters with Prometheus
- Scalable monitoring across infrastructure

### Current Deployment

**Central Services (thor):**
- Grafana - Visualization dashboards
- Prometheus - Metrics storage and querying
- Loki - Log aggregation and storage

**Thor Exporters:**
- node-exporter - System metrics (CPU, memory, disk, network)
- nginx-exporter - Web server metrics
- zfs-exporter - Filesystem health and performance
- cadvisor - Container metrics
- smartctl-exporter - Disk health (SMART data)
- promtail - System log shipping

## Components

### Grafana

**Purpose:** Web interface for visualization and dashboards

**Configuration:** `modules/grafana.nix`

**Features:**
- Pre-configured datasources (Prometheus, Loki)
- Automatic provisioning
- Nginx reverse proxy integration
- Data directory: `/srv/grafana`

**Access:** `http://grafana.{domain}` (via reverse proxy)

**Port:** 3000 (from port registry)

### Prometheus

**Purpose:** Time-series metrics database and scraping orchestrator

**Configuration:** `modules/prometheus.nix`

**Features:**
- 15s scrape interval
- 30 day retention
- Automatic scrape config merging from exporters
- Global config for all hosts

**Port:** 9090 (from port registry)

**Data location:** `/var/lib/prometheus`

### Loki

**Purpose:** Log aggregation and storage

**Configuration:** `modules/loki.nix`

**Features:**
- 7 day retention
- TSDB storage backend
- Filesystem storage
- Compaction and retention management
- Data directory: `/srv/loki`

**Port:** 3100 (from port registry)

**Storage:**
- Chunks: `/srv/loki/chunks`
- Index: `/srv/loki/tsdb-index`
- Cache: `/srv/loki/tsdb-cache`

### Promtail

**Purpose:** Ships system logs to Loki

**Configuration:** `modules/hosts/thor/promtail.nix`

**Features:**
- Systemd journal scraping
- Automatic labeling (host, unit, level)
- 12h max age for logs
- Positions tracking

**Port:** 9080 (from port registry)

### Exporters

Exporters collect metrics from specific systems and expose them for Prometheus scraping.

#### Node Exporter

**Metrics:** System-level (CPU, memory, disk, network, thermal)

**Port:** 9100

**Enabled collectors:**
- systemd - Service status
- processes - Process counts
- filesystem - Disk usage
- thermal_zone - Temperature sensors

#### Nginx Exporter

**Metrics:** Web server performance

**Port:** 9113

**Provides:** Request rates, connections, upstream status

#### ZFS Exporter

**Metrics:** Filesystem health and performance

**Port:** 9134

**Provides:** Pool status, dataset metrics, I/O statistics

#### cAdvisor

**Metrics:** Container resource usage

**Port:** 9338

**Provides:** CPU, memory, network, disk per container

#### Smartctl Exporter

**Metrics:** Disk health via SMART

**Port:** 9633

**Provides:** Disk temperature, error counts, health status

## Configuration

### Custom Options

**Monitoring Server Address:**

```nix
# modules/niflheim/monitoring.nix
flake.niflheim.monitoring.serverAddress = "thor";  # Default
```

Used by exporters and promtail to connect to central services.

### Port Registry

All monitoring ports defined in `modules/niflheim/ports.nix`:

```nix
# Monitoring services
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
```

## Adding New Exporters

### Step 1: Choose Exporter Type

Determine what metrics you need:
- System metrics → node-exporter (already installed)
- Application metrics → Application-specific exporter
- Database metrics → Database exporter (postgres, mysql, etc.)
- Network metrics → SNMP exporter, blackbox exporter

### Step 2: Add Port to Registry

```nix
# modules/niflheim/ports.nix
_: {
  flake.niflheim.ports.exporters = {
    # ... existing exporters
    myexporter = 9999;  # Choose appropriate port
  };
}
```

### Step 3: Create Exporter Module

Create host-specific exporter in `modules/hosts/{hostname}/`:

```nix
# modules/hosts/thor/myservice-exporter.nix
{ inputs, ... }: let
  port = inputs.self.niflheim.ports.exporters.myexporter;
in {
  # Configure local exporter service
  flake.modules.nixos.thor = {
    services.prometheus.exporters.myexporter = {
      enable = true;
      inherit port;
      # ... exporter-specific config
    };
  };

  # Register with Prometheus (extends global config)
  flake.modules.nixos.prometheus = {
    services.prometheus.scrapeConfigs = [{
      job_name = "myexporter";
      static_configs = [{
        targets = ["thor:${toString port}"];
        labels.instance = "thor";
      }];
    }];
  };
}
```

### Step 4: Commit and Deploy

```bash
# Add new file to git
git add modules/hosts/thor/myservice-exporter.nix

# Deploy
nixos-rebuild switch --flake .#thor
```

### Step 5: Verify

Check exporter is running and Prometheus is scraping:

```bash
# Check exporter service
systemctl status prometheus-myexporter-exporter

# Check metrics endpoint
curl http://localhost:9999/metrics

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | jq
```

## Real-World Examples

### Node Exporter (System Metrics)

```nix
# modules/hosts/thor/node-exporter.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.thor = {
    services.prometheus.exporters.node = {
      enable = true;
      port = ports.exporters.node;
      enabledCollectors = [
        "systemd"
        "processes"
        "filesystem"
        "thermal_zone"
      ];
    };
  };

  flake.modules.nixos.prometheus = {
    services.prometheus.scrapeConfigs = [{
      job_name = "node-exporter";
      static_configs = [{
        targets = ["thor:${toString ports.exporters.node}"];
      }];
    }];
  };
}
```

### Promtail (Log Shipping)

```nix
# modules/hosts/thor/promtail.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) monitoring ports;
in {
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
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "thor";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal__systemd_unit"];
              target_label = "unit";
            }
            {
              source_labels = ["__journal_priority_keyword"];
              target_label = "level";
            }
          ];
        }];
      };
    };
  };
}
```

### Grafana with Datasources

```nix
# modules/grafana.nix
{ inputs, ... }: let
  inherit (inputs.self.niflheim) server monitoring ports;
in {
  flake.modules.nixos.grafana = {
    services.grafana = {
      enable = true;
      settings.server = {
        http_port = ports.grafana;
        domain = "grafana.${server.domain}";
        root_url = "https://grafana.${server.domain}";
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://${monitoring.serverAddress}:${toString ports.prometheus}";
            isDefault = true;
          }
          {
            name = "Loki";
            type = "loki";
            url = "http://${monitoring.serverAddress}:${toString ports.loki}";
          }
        ];
      };
    };
  };
}
```

## Accessing Dashboards

### Grafana Web Interface

**URL:** `https://grafana.{your-domain}`

**First-time setup:**
1. Navigate to Grafana URL
2. Create initial admin user
3. Datasources auto-configured (Prometheus, Loki)
4. Import dashboards or create custom ones

### Prometheus Web Interface

**Direct access:** `http://{monitoring-server}:9090`

**Via port forward:**
```bash
ssh -L 9090:localhost:9090 thor
# Access at http://localhost:9090
```

**Query examples:**
- `up` - Check which exporters are up
- `node_cpu_seconds_total` - CPU metrics
- `rate(node_network_receive_bytes_total[5m])` - Network traffic

### Loki/Promtail Logs

Access via Grafana:
1. Open Grafana
2. Explore → Select "Loki" datasource
3. Query logs:
   - `{host="thor"}` - All logs from thor
   - `{unit="nginx.service"}` - Nginx logs
   - `{level="error"}` - Error-level logs

## Best Practices

### Exporter Placement

- **Host-specific exporters** → `modules/hosts/{hostname}/`
- **Service-specific exporters** → Same host as service
- Use underscore prefix (`_exporter.nix`) if side effects/security concerns

### Port Selection

- Use standard Prometheus exporter ports (9xxx series)
- Check https://github.com/prometheus/prometheus/wiki/Default-port-allocations
- Add to port registry to prevent conflicts

### Retention Policies

**Prometheus:** 30 days (configured in `prometheus.nix`)
- Adjust via `retentionTime = "Xd"`

**Loki:** 7 days (configured in `loki.nix`)
- Adjust via `limits_config.retention_period`

### Scrape Intervals

**Default:** 15s (configured in Prometheus global config)

For high-volume exporters, override in scrape config:
```nix
scrapeConfigs = [{
  job_name = "high-frequency";
  scrape_interval = "5s";  # Override global
  static_configs = [{ targets = ["..."]; }];
}];
```

### Labels and Relabeling

Add consistent labels for filtering:
```nix
static_configs = [{
  targets = ["thor:9100"];
  labels = {
    instance = "thor";
    role = "server";
    environment = "production";
  };
}];
```

## Troubleshooting

### Exporter Not Showing in Prometheus

**Symptoms:** Exporter service running but not in Prometheus targets

**Solutions:**
1. Check exporter module extends `flake.modules.nixos.prometheus`
2. Verify port matches between exporter and scrape config
3. Check firewall: `ss -tlnp | grep <port>`
4. Review Prometheus logs: `journalctl -u prometheus -f`

### Metrics Not Appearing

**Symptoms:** Exporter up but no metrics in Prometheus

**Solutions:**
1. Test metrics endpoint: `curl http://localhost:<port>/metrics`
2. Check Prometheus scrape errors: Navigate to Prometheus UI → Status → Targets
3. Verify exporter collectors enabled (for node-exporter)

### Logs Not in Loki

**Symptoms:** Promtail running but logs not in Grafana

**Solutions:**
1. Check promtail status: `systemctl status promtail`
2. Verify Loki URL: Should be `http://{monitoring-server}:3100`
3. Check promtail logs: `journalctl -u promtail -f`
4. Test Loki API: `curl http://localhost:3100/ready`

### High Memory Usage

**Prometheus:** Large retention or high cardinality

**Solutions:**
- Reduce retention: `retentionTime = "15d"`
- Limit scrape targets
- Reduce scrape frequency for high-volume exporters

**Loki:** Large log volume

**Solutions:**
- Reduce retention: `limits_config.retention_period = "72h"`
- Filter logs in promtail scrape configs
- Adjust compaction settings

## See Also

- [Architecture - Dual-Namespace Pattern](architecture.md#rule-11-dual-namespace-pattern)
- [Architecture - Host-Level Service Extensions](architecture.md#rule-13-host-level-service-extensions)
- [Port Registry Guide](port-registry.md)
- `modules/prometheus.nix` - Prometheus configuration
- `modules/grafana.nix` - Grafana configuration
- `modules/loki.nix` - Loki configuration
- `modules/hosts/thor/` - Exporter modules
