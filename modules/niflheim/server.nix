{lib, ...}: {
  options.flake.niflheim.server = with lib; {
    domain = mkOption {
      type = types.str;
      default = "greensroad.uk";
    };
  };
}
