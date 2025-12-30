{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixos-raspberrypi.lib.nixosSystem {
    specialArgs = inputs;
    modules = [
      {
        imports = with inputs.nixos-raspberrypi.nixosModules;
          [
            raspberry-pi-5.base
            raspberry-pi-5.page-size-16k
            raspberry-pi-5.display-vc4
            raspberry-pi-5.bluetooth
          ]
          ++ [
            inputs.srvos.nixosModules.common
          ]
          ++ (with inputs.self.modules.nixos; [
            common
            loki
            wireless
          ]);
      }
    ];
  };

  flake.modules.nixos.loki = {config, ...}: {
    networking.hostName = "loki";

    system.nixos.tags = let
      cfg = config.boot.loader.raspberryPi;
    in [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

    boot.loader.raspberryPi.bootloader = "kernel";

    services = {
      tailscale = {
        useRoutingFeatures = "server";
      };

      udev.extraRules = ''
        # Ignore partitions with "Required Partition" GPT partition attribute
        # On our RPis this is firmware (/boot/firmware) partition
        ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
        ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
        ENV{UDISKS_IGNORE}="1"
      '';
    };

    boot.tmp.useTmpfs = true;
  };
}
