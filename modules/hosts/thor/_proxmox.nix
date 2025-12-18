{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
  ipAddress = "192.168.68.128";
in {
  flake.modules.nixos.thor = {...}: {
    imports = [inputs.self.modules.nixos.proxmox];

    services.proxmox-ve = {
      inherit ipAddress;
      bridges = ["br0"];
    };

    services.nginx.virtualHosts."proxmox.${server.domain}" = {
      locations."/" = {
        proxyPass = "https://127.0.0.1:8006";
        proxyWebsockets = true;
      };
    };
  };
}
