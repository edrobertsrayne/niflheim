{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.media = {config, ...}: let
    cfg = config.services.bazarr;
    url = "bazarr.${server.domain}";
  in {
    users.users.${cfg.user}.extraGroups = ["tank"];
    services = {
      bazarr = {
        enable = true;
        listenPort = ports.media.bazarr;
        dataDir = "/srv/bazarr";
      };
      nginx.virtualHosts."${url}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString cfg.listenPort}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
