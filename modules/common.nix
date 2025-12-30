{inputs, ...}: {
  flake.modules.nixos.common = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.disko.nixosModules.disko
      inputs.agenix.nixosModules.default
      inputs.srvos.nixosModules.common

      avahi
      capslock
      docker
      home-manager
      locale
      nix
      tailscale
      user
    ];

    security.polkit.enable = true;

    services.openssh.enable = true;

    system.stateVersion = "25.05";

    environment.systemPackages = with pkgs; [
      wget
      curl
      vim
      git
    ];
  };
}
