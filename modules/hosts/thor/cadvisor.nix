_: {
  flake.modules.nixos.thor = _: {
    services.cadvisor = {
      enable = true;
      port = 9338;
    };
  };

  flake.modules.nixos.prometheus = _: {
    services.prometheus.scrapeConfigs = [
      {
        job_name = "cadvisor";
        static_configs = [
          {
            targets = ["thor:9338"];
          }
        ];
      }
    ];
  };
}
