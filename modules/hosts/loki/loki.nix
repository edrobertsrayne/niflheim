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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINW5tgMzPytrfk373U9EfL5ol6No9lIelF6dL8ZYSe0B ed@thor"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam ed@freya"
      ];
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1 ed@imac"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINW5tgMzPytrfk373U9EfL5ol6No9lIelF6dL8ZYSe0B ed@thor"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam ed@freya"
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
