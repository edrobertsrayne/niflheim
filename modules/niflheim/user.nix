{lib, ...}: {
  options.flake.niflheim.user = with lib; {
    username = mkOption {
      type = types.str;
      default = "ed";
    };
    fullname = mkOption {
      type = types.str;
      default = "Ed Roberts Rayne";
    };
    email = mkOption {
      type = types.str;
      default = "ed.rayne@gmail.com";
    };
  };
}
