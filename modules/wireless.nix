_: {
  flake.modules.nixos.wireless = {
    networking = {
      useNetworkd = true;

      wireless.iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
          Settings.AutoConnect = true;
        };
      };
    };
  };
}
