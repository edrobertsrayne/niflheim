_: {
  flake.modules.homeManager.hyprland = {config, ...}: {
    wayland.windowManager.hyprland.settings = {
      source = ["${config.xdg.configHome}/hypr/colors.conf"];
      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 2;
        layout = "dwindle";
        allow_tearing = false;
        resize_on_border = false;
        "col.active_border" = "$primary";
        "col.inactive_border" = "$surface-alpha";
      };

      decoration = {
        inactive_opacity = 0.8;
        dim_inactive = true;
        dim_strength = 0.1;
        rounding = 12;
        shadow = {
          color = "rgba(21212199)";
          enabled = true;
          range = 25;
          render_power = 3;
          offset = "0 2";
          scale = 1.0;
        };
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
          xray = false;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };
      };

      group = {
        "col.border_active" = "$primary";
        "col.border_inactive" = "$surface";
        "col.border_locked_active" = "$secondary";
      };

      animations = {
        enabled = true;
        bezier = [
          "easeInOut,  0.4, 0.0, 0.2, 1"
          "easeIn, 0.0, 0.0, 0.2, 1"
          "easeOut, 0.4, 0.0, 1, 1"
        ];

        animation = [
          "windowsIn, 1, 3, easeOut, popin 90%"
          "windowsOut, 1, 3, easeIn, popin 90%"
          "windowsMove, 1, 3, easeInOut, slide"
          "fadeIn, 1, 3, easeOut"
          "fadeOut, 1, 3, easeIn"
          "fadeSwitch, 1, 3, easeInOut"
          "fadeShadow, 1, 3, easeInOut"
          "fadeDim, 1, 3, easeInOut"
          "workspaces, 1, 4, easeInOut, slide"
          "specialWorkspace, 1, 3, easeOut, slidevert"
          "border, 1, 2, easeOut"
          "borderangle, 1, 100, easeOut, loop"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        anr_missed_pings = 3;
      };
    };
  };
}
