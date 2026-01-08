{
  inputs,
  lib,
  ...
}: {
  flake.lib.hosts = let
    nixosSystem = system: name:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.self.modules.nixos.home-manager
          (inputs.self.modules.nixos.${name} or {})
          {
            networking.hostId = lib.mkDefault (builtins.substring 0 8 (
              builtins.hashString "sha256" "${name}"
            ));
            networking.hostName = lib.mkDefault name;
            nixpkgs.hostPlatform = lib.mkDefault system;
            system.stateVersion = "25.05";
          }
        ];
      };

    darwinSystem = system: name:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          inputs.self.modules.darwin.darwin
          (inputs.self.modules.darwin.${name} or {})
          {
            networking.hostName = lib.mkDefault name;
            nixpkgs.hostPlatform = lib.mkDefault system;
            system.stateVersion = 6;
          }
        ];
      };
  in {
    inherit nixosSystem darwinSystem;
  };
}
