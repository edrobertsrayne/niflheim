{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.nix-colors.homeManagerModules.default
    ];

    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    colorScheme = inputs.nix-colors.colorSchemes.tokyodark;

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
        input_path = '${config.xdg.dataHome}/matugen/gtk.css'
        output_path = '${config.xdg.configHome}/gtk-3.0/gtk.css'

        [templates.gtk4]
        input_path = '${config.xdg.dataHome}/matugen/gtk.css'
        output_path = '${config.xdg.configHome}/gtk-4.0/gtk.css'

        [templates.wlogout]
        input_path = '${config.xdg.dataHome}/matugen/wlogout.css'
        output_path = '${config.xdg.configHome}/wlogout/colors.css'

        [templates.ghostty]
        input_path = '${config.xdg.dataHome}/matugen/ghostty'
        output_path = '${config.xdg.configHome}/ghostty/themes/matugen'
        post_hook = 'pkill -SIGUSR2 ghostty'

        [templates.cava]
        input_path = '${config.xdg.dataHome}/matugen/cava'
        output_path = '${config.xdg.configHome}/cava/config'
        post_hook = 'pkill -USR1 cava'
      '';

      dataFile = {
        "matugen/hyprland.conf".text = ''
          $image = {{image}}
          <* for name, value in colors *>
          ''${{name}} = rgba({{value.default.hex_stripped}}ff)
          ''${{name}}-alpha = rgba({{value.default.hex_stripped}}7f)
          <* endfor *>
        '';

        "matugen/colors.css".text = ''
          <* for name, value in colors *>
            @define-color {{name}} {{value.default.hex}};
          <* endfor *>
        '';
        "matugen/wlogout.css".text = ''
          @define-color surface_dim {{colors.surface_dim.default.rgba | set_alpha: 0.60}};
          @define-color on_surface {{colors.on_surface.default.rgba}};
          @define-color surface_container_low {{colors.surface_container_low.default.rgba | set_alpha: 0.70}};
          @define-color primary {{colors.primary.default.rgba | set_alpha: 0.80}};
          @define-color on_primary {{colors.on_primary.default.rgba}};
          @define-color primary_container {{colors.primary_container.default.rgba | set_alpha: 0.90}};
          @define-color on_primary_container {{colors.on_primary_container.default.rgba}};
        '';
        "matugen/gtk.css".text = builtins.readFile ./gtk.css.mustache;
        "matugen/ghostty".text = builtins.readFile ./ghostty.mustache;
        "matugen/cava".text = ''
          [color]
          background = 'default'
          foreground = '{{colors.primary.default.hex}}'

          gradient = 1
          gradient_color_1 = '#${config.colorScheme.palette.base0E}'
          gradient_color_2 = '#${config.colorScheme.palette.base0D}'
          gradient_color_3 = '#${config.colorScheme.palette.base0C}'
          gradient_color_4 = '#${config.colorScheme.palette.base0B}'
          gradient_color_5 = '#${config.colorScheme.palette.base0A}'
          gradient_color_6 = '#${config.colorScheme.palette.base09}'
          gradient_color_7 = '#${config.colorScheme.palette.base08}'
        '';
      };
    };
  };
}
