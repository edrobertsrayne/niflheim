{
  flake.modules.nixos.networking = {
    networking = {
      firewall = {
        enable = true;
        allowPing = true;
      };
    };
  };
}
