{inputs, ...}: let
  inherit (inputs.self.lib.hosts) nixosSystem darwinSystem;
in {
  flake.nixosConfigurations = {
    freya = nixosSystem "x86_64-linux" "freya";
    thor = nixosSystem "x86_64-linux" "thor";
  };

  flake.darwinConfigurations = {
    odin = darwinSystem "x86_64-darwin" "odin";
  };
}
