_: {
  flake.modules.homeManager.utilities = {
    programs.nh = {
      enable = true;
      flake = "github:edrobertsrayne/nix-config";
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 3 --keep-since 5d";
      };
    };
  };
}
