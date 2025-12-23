{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.home-assistant = {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/srv/homeassistant:/config"
        ];
        extraOptions = [
          "--network=host"
          "--pull=always"
        ];
      };
    };
    systemd.tmpfiles.rules = [
      "d /srv/homeassistant 0755 root root"
    ];

    services.nginx.virtualHosts."home.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.homeAssistant}";
        proxyWebsockets = true;
      };
    };
  };
}
