{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules = {
    nixos.bun = {
      programs.nix-ld = {
        enable = true;
        libraries = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
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
