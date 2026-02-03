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
      };

      environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        fastfetch
      ];
    };

    homeManager.hyprland = {
      pkgs,
      lib,
      ...
    }: let
      noctalia-shell = lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      wayland.windowManager.hyprland = {
        settings = {
          exec-once = ["${noctalia-shell}"];

          bindd = [
            # Core UI
            "SUPER, SPACE, App launcher, exec, ${noctalia-shell} ipc call launcher toggle"
            "SUPER, S, Control center, exec, ${noctalia-shell} ipc call controlCenter toggle"
            "SUPER, comma, Settings, exec, ${noctalia-shell} ipc call settings toggle"

            # Quick access
            "SUPER, V, Clipboard history, exec, ${noctalia-shell} ipc call launcher clipboard"
            "SUPER, period, Emoji picker, exec, ${noctalia-shell} ipc call launcher emoji"
            "SUPER, grave, Window switcher, exec, ${noctalia-shell} ipc call launcher windows"
            "SUPER, escape, Session menu, exec, ${noctalia-shell} ipc call sessionMenu toggle"
          ];

          # Volume and brightness (repeating + locked)
          bindeld = [
            ", XF86AudioRaiseVolume, Volume up, exec, ${noctalia-shell} ipc call volume increase"
            ", XF86AudioLowerVolume, Volume down, exec, ${noctalia-shell} ipc call volume decrease"
            ", XF86AudioMute, Mute, exec, ${noctalia-shell} ipc call volume muteOutput"
            ", XF86MonBrightnessUp, Brightness up, exec, ${noctalia-shell} ipc call brightness increase"
            ", XF86MonBrightnessDown, Brightness down, exec, ${noctalia-shell} ipc call brightness decrease"
          ];

          # Media controls (locked)
          bindld = [
            ", XF86AudioPlay, Play/pause, exec, ${noctalia-shell} ipc call media playPause"
            ", XF86AudioNext, Next track, exec, ${noctalia-shell} ipc call media next"
            ", XF86AudioPrev, Previous track, exec, ${noctalia-shell} ipc call media previous"
          ];
        };

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
