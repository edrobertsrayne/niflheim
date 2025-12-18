{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules = {
    nixos.bun = {pkgs, ...}: {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          vips
          stdenv.cc.cc.lib
        ];
      };
      home-manager.users.${username}.imports = [
        inputs.self.modules.homeManager.bun
      ];
    };

    homeManager.bun = {
      programs.bun.enable = true;
    };
  };
}
