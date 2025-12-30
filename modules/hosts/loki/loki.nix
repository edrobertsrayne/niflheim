{inputs, ...}: {
  flake.nixosConfigurations.loki = inputs.nixos-raspberrypi.lib.nixosSystem {
    specialArgs = inputs;
    modules = [
      {
        imports = with inputs.self.modules.nixos; [loki];
      }
    ];
  };

  flake.modules.nixos.loki = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      inputs.srvos.nixosModules.desktop
      common
      wireless
      rpi5
      retroarch
    ];

    networking.hostName = "loki";

    # GPU acceleration for VideoCore VII
    # Enables Vulkan 1.2 and OpenGL ES 3.1 for gaming/emulation
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };

    # Vulkan support for VideoCore VII GPU
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
      mesa
    ];

    # TODO: GPU overclock for demanding emulation
    # Add to boot.loader.raspberryPi.firmwareConfig:
    # gpu_freq=800        # Stock: 800MHz
    # gpu_freq=900        # Mild overclock (+12.5%)
    # gpu_freq=1000       # Aggressive (+25%, may require cooling)
    # over_voltage_delta=50000  # +0.05V (required for 1GHz)
  };
}
