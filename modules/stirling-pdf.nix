{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
in {
  flake.modules.nixos.stirling-pdf = {
    services.stirling-pdf.enable = true;

    services.nginx.virtualHosts."stirling-pdf.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };
}
