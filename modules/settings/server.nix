{lib, ...}: {
  options.flake.settings.server = with lib; {
    domain = mkOption {
      type = types.str;
      default = "greensroad.uk";
    };
    cloudflare = mkOption {
      type = types.submodule {
        options = {
          tunnel = mkOption {
            type = types.str;
          };
          secret = mkOption {
            type = types.path;
          };
        };
      };
    };
  };
}
