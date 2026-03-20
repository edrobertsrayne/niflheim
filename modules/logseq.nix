{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.portainer = {
    virtualisation.oci-containers = {
      backend = "docker";
      containers.logseq = {
        image = "ghcr.io/logseq/logseq-webapp:latest";
        autoStart = true;

        ports = [
          "${toString ports.logseq}:80"
        ];

        volumes = [
          "portainer_data:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];

        extraOptions = [
          "--pull=always"
        ];
      };
    };

    services.nginx.virtualHosts."notes.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.logseq}";
        proxyWebsockets = true;
      };
    };
  };
}
