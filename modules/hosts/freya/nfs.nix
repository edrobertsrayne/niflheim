_: {
  flake.modules.nixos.freya = {
    services.rpcbind.enable = true; # Required for NFS
    boot.supportedFilesystems = ["nfs"]; # Ensure kernel module loads
    systemd.targets.network-online.enable = true;

    # Mount configurations using systemd automount for reliability
    # Mounts happen on-demand (first access) instead of at boot
    # Benefits: faster boot, auto-retry on connection drops, no boot blocking
    fileSystems = {
      "/mnt/downloads" = {
        device = "thor:/downloads";
        fsType = "nfs4";
        options = [
          "soft"
          "bg"
          "vers=4"
          "nconnect=4"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=90"
        ];
      };
      "/mnt/media" = {
        device = "thor:/media";
        fsType = "nfs4";
        options = [
          "soft"
          "bg"
          "vers=4"
          "nconnect=4"
          "ro"
          "noauto"
          "x-systemd.automount"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=90"
        ];
      };
    };
  };
}
