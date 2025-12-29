{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.nixos = {
    nix = {
      enable = true;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        warn-dirty = false;
        trusted-users = ["root" "${username}"];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-substituters = [
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        extra-substituters = [
          "https://walker.cachix.org"
          "https://walker-git.cachix.org"
          "https://nixos-raspberrypi.cachix.org"
        ];
        extra-trusted-public-keys = [
          "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
          "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
    system.autoUpgrade = {
      enable = true;
      flake = "github:edrobertsrayne/niflheim";
      flags = [];
      dates = "04:00";
    };

    nixpkgs.config.allowUnfree = true;
  };

  flake.modules.darwin.darwin = {
    nix.enable = false; # nix daemon managed by determinant

    nixpkgs.config.allowUnfree = true;
  };
}
