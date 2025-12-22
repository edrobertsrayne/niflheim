_: {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.nginx = {
      enable = true;
      port = 9113;
      scrapeUri = "http://localhost/nginx_status";
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "nginx-exporter";
        static_configs = [
          {
            targets = ["thor:9113"];
          }
        ];
      }
    ];
  };
}
