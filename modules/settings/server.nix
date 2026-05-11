{lib, ...}: {
  options.flake.settings.server = with lib; {
    domain = mkOption {
      type = types.str;
      default = "greensroad.uk";
    };
  };
}
