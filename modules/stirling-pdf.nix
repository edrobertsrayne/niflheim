{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.stirling-pdf = {
    services.stirling-pdf = {
      enable = true;
      port = ports.stirlingPdf;
    };

    services.nginx.virtualHosts."stirling-pdf.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.stirlingPdf}";
        proxyWebsockets = true;
      };
    };
  };
}
