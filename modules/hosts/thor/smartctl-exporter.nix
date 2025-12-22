_: {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.smartctl = {
      enable = true;
      port = 9633;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "smartctl-exporter";
        static_configs = [
          {
            targets = ["thor:9633"];
          }
        ];
      }
    ];
  };
}
