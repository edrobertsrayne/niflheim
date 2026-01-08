{inputs, ...}: {
  flake.modules.nixos.common = {
    imports = with inputs.self.modules.nixos; [
      avahi
      nix
      ssh
      user
    ];
  };
}
