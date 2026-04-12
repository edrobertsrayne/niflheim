{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.media = {
    services.seerr.enable = true;

    services.nginx.virtualHosts = {
      "jellyseerr.${server.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString ports.media.seerr}";
          proxyWebsockets = true;
        };
      };
      "seerr.${server.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString ports.media.seerr}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
