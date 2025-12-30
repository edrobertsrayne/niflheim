{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.home-manager = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = {
        imports = [(inputs.self.modules.homeManager.${config.networking.hostName} or {})];
        home = {
          username = lib.mkDefault username;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = "${config.system.stateVersion}";
          enableNixpkgsReleaseCheck = false;
        };
      };
    };
  };

  flake.modules.darwin.home-manager = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.darwinModules.home-manager];
    users.users.${username} = {
      name = "${username}";
      home = "/Users/${username}";
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = {
        imports = [(inputs.self.modules.homeManager.${config.networking.hostName} or {})];
        home = {
          username = lib.mkDefault username;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = "25.05";
        };
        programs.home-manager.enable = true;
      };
    };
  };
}
