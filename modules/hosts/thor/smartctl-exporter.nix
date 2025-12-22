{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.thor = _: {
    services.prometheus.exporters.smartctl = {
      enable = true;
      port = ports.exporters.smartctl;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "smartctl-exporter";
        static_configs = [
          {
            targets = ["thor:${toString ports.exporters.smartctl}"];
          }
        ];
      }
    ];
  };
}
