{inputs, ...}: let
  inherit (inputs.self.niflheim) server ports;
in {
  flake.modules.nixos.immich = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.immich;
    mediaDir = "/mnt/ssd/immich";
  in {
    services.immich = {
      enable = true;
      port = ports.immich;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = mediaDir;
    };

    # Hardware acceleration (Intel VA-API)
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        intel-compute-runtime
        vpl-gpu-rt
        intel-media-driver
      ];
    };

    # User permissions
    users.users.${cfg.user}.extraGroups = ["video" "render"];

    # Directory setup
    systemd.tmpfiles.rules = [
      "d ${mediaDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

    # Ensure mount exists before tmpfiles
    systemd.services.systemd-tmpfiles-setup.after = ["mnt-ssd.mount"];

    # Nginx reverse proxy
    services.nginx.virtualHosts."photos.${server.domain}" = {
      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
        proxyWebsockets = true;
      };
    };
  };
}
