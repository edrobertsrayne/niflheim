{inputs, ...}: let
  inherit (inputs.self.settings.user) username;
in {
  flake.modules.nixos.nix = {
    lib,
    config,
    ...
  }: {
    nix = {
      enable = true;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        trusted-users = ["root" "${username}" "@wheel"];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      optimise.automatic = lib.mkDefault (!config.boot.isContainer);
    };

    system.autoUpgrade = {
      enable = true;
      flake = "github:edrobertsrayne/nix-config";
      flags = [];
      dates = "04:00";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
