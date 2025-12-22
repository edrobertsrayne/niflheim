{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.nginx = {
      enable = true;
      port = ports.exporters.nginx;
      scrapeUri = "http://localhost/nginx_status";
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "nginx-exporter";
        static_configs = [
          {
            targets = ["thor:${toString ports.exporters.nginx}"];
          }
        ];
      }
    ];
  };
}
