{inputs, ...}: let
  inherit (inputs.self.niflheim.server) domain;
in {
  flake.modules.nixos.karakeep = {config, ...}: let
    url = "keep.${domain}";
    port = 8081;
  in {
    age.secrets.karakeep.file = ../secrets/karakeep.age;
    services = {
      karakeep = {
        enable = true;
        extraEnvironment = {
          PORT = "${toString port}";
        };
        environmentFile = config.age.secrets.karakeep.path;
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
