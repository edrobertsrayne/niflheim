{inputs, ...}: let
  inherit (inputs.self.niflheim) monitoring;
in {
  flake.modules.nixos.thor = _: {
    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };

        positions.filename = "/var/lib/promtail/positions.yaml";

        clients = [
          {
            url = "http://${monitoring.serverAddress}:3100/loki/api/v1/push";
          }
        ];

        scrape_configs = [
          {
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
                source_labels = ["__journal__hostname"];
                target_label = "hostname";
              }
              {
                source_labels = ["__journal_priority_keyword"];
                target_label = "level";
              }
            ];
          }
        ];
      };
    };

    systemd.services.promtail.serviceConfig.StateDirectory = "promtail";
  };
}
