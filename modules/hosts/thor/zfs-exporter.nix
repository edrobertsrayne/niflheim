{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.zfs = {
      enable = true;
      port = ports.exporters.zfs;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "zfs-exporter";
        static_configs = [
          {
            targets = ["thor:${toString ports.exporters.zfs}"];
          }
        ];
      }
    ];
  };
}
