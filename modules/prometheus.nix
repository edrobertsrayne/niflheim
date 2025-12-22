_: {
  flake.modules.nixos.prometheus = _: {
    services.prometheus = {
      enable = true;
      port = 9090;
      stateDir = "prometheus";
      globalConfig = {
        scrape_interval = "15s";
        evaluation_interval = "15s";
      };
      retentionTime = "30d";
      # Scrape configs added by individual service modules
      scrapeConfigs = [];
    };
  };
}
