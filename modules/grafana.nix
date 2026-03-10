{inputs, ...}: let
  inherit (inputs.self.niflheim) server monitoring ports;
in {
  flake.modules.nixos.grafana = {config, ...}: {
    age.secrets.grafana = {
      file = ../secrets/grafana.age;
      owner = "grafana";
      group = "grafana";
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = ports.grafana;
          domain = "grafana.${server.domain}";
          root_url = "https://grafana.${server.domain}";
        };
        security.secret_key = "$__file{${config.age.secrets.grafana.path}}";
        analytics.reporting_enabled = false;
      };
      dataDir = "/srv/grafana";
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://${monitoring.serverAddress}:${toString ports.prometheus}";
            isDefault = true;
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://${monitoring.serverAddress}:${toString ports.loki}";
          }
        ];
      };
    };

    services.nginx.virtualHosts."grafana.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.grafana}";
        proxyWebsockets = true;
      };
    };
  };
}
