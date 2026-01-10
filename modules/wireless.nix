_: {
  flake.modules.nixos.wireless = {lib, ...}: {
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = lib.mkDefault true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };
}
