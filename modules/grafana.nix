{inputs, ...}: let
  inherit (inputs.self.niflheim) server monitoring;
in {
  flake.modules.nixos.grafana = {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 3000;
          domain = "grafana.${server.domain}";
          root_url = "https://grafana.${server.domain}";
        };
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
            url = "http://${monitoring.serverAddress}:9090";
            isDefault = true;
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://${monitoring.serverAddress}:3100";
          }
        ];
      };
    };

    services.nginx.virtualHosts."grafana.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };
}
