_: {
  flake.modules.nixos.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wget
      curl
      vim
      tree
      htop
    ];
  };
}
