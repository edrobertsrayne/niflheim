{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixos-raspberrypi.lib.nixosSystem {
    specialArgs = inputs;
    modules = [
      {
        imports = with inputs.self.modules.nixos; [
          loki
        ];
      }
    ];
  };

  flake.modules.nixos.loki = {
    imports = with inputs.self.modules.nixos; [
      common
      wireless
      rpi5
    ];

    networking.hostName = "loki";
  };
}
