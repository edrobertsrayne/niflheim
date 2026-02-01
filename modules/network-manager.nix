{
  flake.modules.nixos.network-manager = {lib, ...}: {
    networking = {
      useNetworkd = false;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless.iwd.enable = true;

      firewall = {
        enable = true;
        allowPing = true;
        logRefusedConnections = lib.mkDefault false;
      };
    };

    systemd.network.wait-online.enable = false;
  };
}
