_: {
  flake.niflheim.ports = {
    # Infrastructure
    ssh = 22;
    http = 80;
    https = 443;
    dns = 53;

    # Monitoring
    prometheus = 9090;
    grafana = 3000;
    loki = 3100;
    promtail = 9080;

    # Exporters (9xxx series)
    exporters = {
      node = 9100;
      nginx = 9113;
      zfs = 9134;
      cadvisor = 9338;
      smartctl = 9633;
    };

    # Media services
    media = {
      jellyfin = 8096;
      jellyseerr = 5055;
      radarr = 7878;
      sonarr = 8989;
      lidarr = 8686;
      bazarr = 6767;
      prowlarr = 9696;
      sabnzbd = 8080;
      transmission = 9091;
      transmissionPeer = 51413;
      flaresolverr = 8191;
    };

    # Applications
    blocky = 4000;
    vaultwarden = 8222;
    portainer = 9000;
    portainerHTTPS = 9443;
    portainerEdge = 8000;
    karakeep = 8081;
    mealie = 8223;
    homeAssistant = 8123;
    stirlingPdf = 8082;

    # Proxmox/Virtualization
    proxmox = 8006;
    proxmoxProxy = 3128;
  };
}
