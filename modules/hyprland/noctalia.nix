{inputs, ...}: {
  flake.modules = {
    nixos.hyprland = {pkgs, ...}: {
      # See https://docs.noctalia.dev/getting-started/nixos/

      imports = [
        inputs.noctalia.nixosModules.default
      ];

      hardware.bluetooth.enable = true;
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
        # tuned.enable = true;
        noctalia-shell.enable = true;
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        fastfetch
      ];
    };

    homeManager.hyprland = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      wayland.windowManager.hyprland = {
        extraConfig = ''
          layerrule {
            name = noctalia
            match:namespace = noctalia-background-.*$
            ignore_alpha = 0.5
            blur = true
            blur_popups = true
          }
        '';
      };
    };
  };
}
