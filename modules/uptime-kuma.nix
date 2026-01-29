{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
  url = "uptime.${server.domain}";
  port = ports.uptime-kuma;
in {
  flake.modules.nixos.uptime-kuma = {
    services = {
      uptime-kuma = {
        enable = true;
        settings = {
          HOST = "127.0.0.1";
          PORT = toString port;
        };
      };

      nginx.virtualHosts."${url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
