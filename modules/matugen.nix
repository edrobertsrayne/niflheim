{inputs, ...}: {
  flake.modules.homeManager.matugen = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg = {
      configFile."matugen/config.toml".text = ''
        [config]

        [templates.hyprland]
        input_path = '${config.xdg.dataHome}/matugen/hyprland.conf'
        output_path = '${config.xdg.configHome}/hypr/colors.conf'
        post_hook = 'hyprctl reload'

        [templates.waybar]
        input_path = '${config.xdg.dataHome}/matugen/colors.css'
        output_path = '${config.xdg.configHome}/waybar/colors.css'
        post_hook = 'pkill -SIGUSR2 waybar'

        [templates.swaync]
        input_path = '${config.xdg.dataHome}/matugen/colors.css'
        output_path = '${config.xdg.configHome}/swaync/colors.css'

        [templates.walker]
        input_path = '${config.xdg.dataHome}/matugen/colors.css'
        output_path = '${config.xdg.configHome}/walker/themes/matugen/colors.css'

        [templates.gtk3]
        input_path = '${config.xdg.dataHome}/matugen/gtk-colors.css'
        output_path = '${config.xdg.configHome}/gtk-3.0/colors.css'

        [templates.gtk4]
        input_path = '${config.xdg.dataHome}/matugen/gtk-colors.css'
        output_path = '${config.xdg.configHome}/gtk-4.0/colors.css'
      '';

      dataFile = {
        "matugen/hyprland.conf".text = ''
          <* for name, value in colors *>
          $image = {{image}}
          ''${{name}} = rgba({{value.default.hex_stripped}}ff)
          <* endfor *>
        '';

        "matugen/colors.css".text = ''
          <* for name, value in colors *>
            @define-color {{name}} {{value.default.hex}};
          <* endfor *>
        '';
        "matugen/gtk-colors.css".text = ''
          @define-color accent_color {{colors.primary_fixed_dim.default.hex}};
          @define-color accent_fg_color {{colors.on_primary_fixed.default.hex}};
          @define-color accent_bg_color {{colors.primary_fixed_dim.default.hex}};
          @define-color window_bg_color {{colors.surface_dim.default.hex}};
          @define-color window_fg_color {{colors.on_surface.default.hex}};
          @define-color headerbar_bg_color {{colors.surface_dim.default.hex}};
          @define-color headerbar_fg_color {{colors.on_surface.default.hex}};
          @define-color popover_bg_color {{colors.surface_dim.default.hex}};
          @define-color popover_fg_color {{colors.on_surface.default.hex}};
          @define-color view_bg_color {{colors.surface.default.hex}};
          @define-color view_fg_color {{colors.on_surface.default.hex}};
          @define-color card_bg_color {{colors.surface.default.hex}};
          @define-color card_fg_color {{colors.on_surface.default.hex}};
          @define-color sidebar_bg_color @window_bg_color;
          @define-color sidebar_fg_color @window_fg_color;
          @define-color sidebar_border_color @window_bg_color;
          @define-color sidebar_backdrop_color @window_bg_color;
        '';
      };
    };
  };
}
