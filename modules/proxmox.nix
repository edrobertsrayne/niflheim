{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.proxmox = {config, ...}: {
    imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

    nixpkgs.overlays = [
      inputs.proxmox-nixos.overlays.x86_64-linux
      # HACK: https://github.com/SaumonNet/proxmox-nixos/issues/70
      (_: super: {
        proxmox-ve = super.proxmox-ve.override (previous: {
          util-linux = previous.wget;
        });
      })
    ];

    services.proxmox-ve = {
      enable = true;
    };

    nix.settings = {
      substituters = ["https://cache.saumon.network/proxmox-nixos"];
      trusted-public-keys = ["proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="];
    };

    assertions = [
      {
        assertion = !config.networking.networkmanager.enable;
        message = "Proxmox requires systemd-networkd. Disable NetworkManager in host config.";
      }
    ];

    networking.firewall = {
      allowedTCPPorts = [
        ports.proxmoxProxy
        ports.proxmox
      ];
      allowedTCPPortRanges = [
        {
          from = 5900;
          to = 5999;
        }
      ];
    };
  };
}
