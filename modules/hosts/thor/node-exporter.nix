_: {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "systemd"
        "processes"
        "filesystem"
        "thermal_zone"
      ];
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = ["thor:9100"];
          }
        ];
      }
    ];
  };
}
