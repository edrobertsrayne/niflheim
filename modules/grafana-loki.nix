{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.grafana-loki = _: {
    services.loki = {
      enable = true;
      dataDir = "/srv/loki";
      configuration = {
        server.http_listen_port = ports.loki;
        auth_enabled = false;

        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore.store = "inmemory";
              replication_factor = 1;
            };
            final_sleep = "0s";
          };
          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 999999;
          chunk_retain_period = "30s";
        };

        schema_config.configs = [
          {
            from = "2024-01-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        storage_config = {
          tsdb_shipper = {
            active_index_directory = "/srv/loki/tsdb-index";
            cache_location = "/srv/loki/tsdb-cache";
          };
          filesystem.directory = "/srv/loki/chunks";
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h"; # 7 days
          retention_period = "168h"; # 7 days
        };

        table_manager = {
          retention_deletes_enabled = true;
          retention_period = "168h"; # 7 days
        };

        compactor = {
          working_directory = "/srv/loki/compactor";
          compaction_interval = "10m";
          retention_enabled = true;
          retention_delete_delay = "2h";
          retention_delete_worker_count = 150;
          delete_request_store = "filesystem";
        };
      };
    };
  };
}
