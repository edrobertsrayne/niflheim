_: {
  flake.modules.nixos.thor = {
    # Configure Samba
    services.samba = {
      enable = true;
      openFirewall = true;
      securityType = "user";
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "media" = {
          "path" = "/mnt/storage/media";
          "browseable" = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
        };
        "downloads" = {
          "path" = "/mnt/ssd/downloads";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
        };
      };
    };

    # Windows network discovery
    services.samba-wsdd.enable = true;
  };
}
