{inputs, ...}: let
  inherit (inputs.self.niflheim.server) domain;
  url = "mealie.${domain}";
  port = 8223;
in {
  flake.modules.nixos.mealie = {config, ...}: {
    age.secrets.mealie.file = ../secrets/mealie.age;

    services = {
      mealie = {
        enable = true;
        inherit port;
        credentialsFile = config.age.secrets.mealie.path;
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
