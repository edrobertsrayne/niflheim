{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixos-raspberrypi.lib.nixosSystem {
    specialArgs = inputs;
    modules = [
      {
        imports = with inputs.nixos-raspberrypi.nixosModules; [
          raspberry-pi-5.base
          raspberry-pi-5.page-size-16k
          raspberry-pi-5.display-vc4
          raspberry-pi-5.bluetooth
          sd-image
          inputs.self.modules.nixos.host-loki
        ];
      }
    ];
  };

  flake.modules.nixos.host-loki = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # Disable nixos-generators default bootloader - use raspberrypi bootloader instead
    boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;

    # Use modern kernel bootloader instead of deprecated kernelboot
    boot.loader.raspberryPi.bootloader = "kernel";

    networking = {
      hostName = "loki";

      useNetworkd = true;
      firewall.allowedUDPPorts = [5353];

      wireless.enable = false;
      wireless.iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
          Settings.AutoConnect = true;
        };
      };
    };
    system.nixos.tags = let
      cfg = config.boot.loader.raspberryPi;
    in [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];
    users.users = {
      nixos = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
        initialHashedPassword = "";
      };

      root.initialHashedPassword = "";

      nixos.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1 ed@imac"
      ];
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1 ed@imac"
      ];
    };

    security.polkit.enable = true;

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services = {
      getty.autologinUser = "nixos";

      openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
      udev.extraRules = ''
        # Ignore partitions with "Required Partition" GPT partition attribute
        # On our RPis this is firmware (/boot/firmware) partition
        ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
        ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
        ENV{UDISKS_IGNORE}="1"
      '';
    };

    nix.settings.trusted-users = ["nixos"];

    system.stateVersion = config.system.nixos.release;

    systemd.network.networks = {
      "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
      "99-wireless-client.dhcp".networkConfig.MulticastDNS = "yes";
    };
    time.timeZone = "UTC";

    environment.systemPackages = with pkgs; [
      tree
    ];

    boot.tmp.useTmpfs = true;
  };
}
