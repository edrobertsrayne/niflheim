_: {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.zfs = {
      enable = true;
      port = 9134;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "zfs-exporter";
        static_configs = [
          {
            targets = ["thor:9134"];
          }
        ];
      }
    ];
  };
}
