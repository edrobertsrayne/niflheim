{inputs, ...}: let
  inherit (inputs.self.niflheim) server;
in {
  flake.modules.nixos.media = {config, ...}: let
    cfg = config.services.sabnzbd;
    url = "sabnzbd.${server.domain}";
  in {
    services = {
      sabnzbd = {
        enable = true;
        openFirewall = true;
      };
    };

    users.users.${cfg.user}.extraGroups = ["tank"];

    systemd.tmpfiles.rules = [
      "d /mnt/ssd/downloads/usenet/complete 0755 ${cfg.user} tank -"
      "d /mnt/ssd/downloads/usenet/incomplete 0755 ${cfg.user} tank -"
    ];

    systemd.services.sabnzbd.preStart = ''
      CONFIG="/var/lib/sabnzbd/sabnzbd.ini"

      if [ -f "$CONFIG" ]; then
        # Update host_whitelist to include necessary hosts
        if ! grep -q "localhost" "$CONFIG"; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, localhost, 127.0.0.1, ${url}/" "$CONFIG"
        elif ! grep -q "${url}" "$CONFIG"; then
          sed -i "s/^host_whitelist = \(.*\)$/host_whitelist = \1, ${url}/" "$CONFIG"
        fi

        # Update local_ranges
        if grep -q "^local_ranges = ,$" "$CONFIG"; then
          sed -i "s/^local_ranges = ,$/local_ranges = 127.0.0.1, ::1/" "$CONFIG"
        fi
      fi
    '';

    services.nginx.virtualHosts."${url}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Host $host;
        '';
      };
    };
  };
}
