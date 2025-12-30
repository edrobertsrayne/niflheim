{inputs, ...}: {
  flake.modules.nixos.retroarch = {pkgs, ...}: {
    # RetroArch with curated cores for retro gaming emulation
    # Optimized for Raspberry Pi 5 but hardware-agnostic

    imports = [inputs.srvos.nixosModules.desktop];

    environment.systemPackages = with pkgs; [
      # RetroArch with comprehensive core selection
      (retroarch.withCores (cores:
        with cores; [
          # Nintendo consoles
          fceumm # NES/Famicom
          snes9x # SNES
          mupen64plus # N64
          dolphin # GameCube/Wii

          # Sega consoles
          genesis-plus-gx # Genesis/Mega Drive/Master System/Game Gear
          flycast # Dreamcast/Naomi

          # Sony consoles
          beetle-psx-hw # PlayStation 1 (hardware accelerated)

          # Handheld systems
          gambatte # Game Boy/Game Boy Color
          mgba # Game Boy Advance
          desmume # Nintendo DS

          # Other systems
          dosbox-pure # DOS games
          scummvm # Point-and-click adventures

          # Optional: More demanding cores (may require performance tuning)
          citra # Nintendo 3DS
          beetle-saturn # Sega Saturn
        ]))

      # Additional emulation tools
      antimicrox # Controller-to-keyboard mapper (for non-libretro emulators)

      # Graphics packages for GPU acceleration
      vulkan-tools
      mesa
    ];

    # Controller/gamepad support
    hardware.uinput.enable = true;
    services.udev.packages = with pkgs; [
      game-devices-udev-rules
    ];

    # GPU acceleration dependencies
    hardware.graphics.enable = true;
  };
}
