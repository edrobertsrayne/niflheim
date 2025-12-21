_: {
  flake.modules.nixos.thor = {
    # Configure Samba
    services.samba = {
      enable = true;
      openFirewall = true;
    };

    # Windows network discovery
    services.samba-wsdd.enable = true;
  };
}
