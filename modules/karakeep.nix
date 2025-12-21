{inputs, ...}: let
  inherit (inputs.self.niflheim.server) domain;
in {
  flake.modules.nixos.karakeep = _: let
    url = "keep.${domain}";
    port = 8081;
  in {
    services = {
      karakeep = {
        enable = true;
        extraEnvironment = {
          PORT = "${toString port}";
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
