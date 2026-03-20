{inputs, ...}: let
  inherit (inputs.self.lib.hosts) nixosSystem;
in {
  flake.nixosConfigurations = {
    thor = nixosSystem "x86_64-linux" "thor";
  };
}
