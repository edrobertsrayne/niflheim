{inputs, ...}: {
  flake.modules.nixos.common = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos;
      [
        avahi
        capslock
        docker
        locale
        networking
        nix
        ssh
        tailscale
        user
      ]
      ++ [
        inputs.agenix.nixosModules.default
        inputs.disko.nixosModules.disko
      ];

    environment.systemPackages = with pkgs; [
      wget
      curl
      vim
      tree
      htop
    ];
  };
}
