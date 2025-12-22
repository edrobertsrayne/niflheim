{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.thor = _: {
    services.cadvisor = {
      enable = true;
      port = ports.exporters.cadvisor;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "cadvisor";
        static_configs = [
          {
            targets = ["thor:${toString ports.exporters.cadvisor}"];
          }
        ];
      }
    ];
  };
}
