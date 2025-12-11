{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
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
        input_path = '${config.xdg.dataHome}/matugen/gtk.css'
        output_path = '${config.xdg.dataHome}/matugen/gtk3.css'

        [templates.gtk4]
        input_path = '${config.xdg.dataHome}/matugen/gtk.css'
        output_path = '${config.xdg.dataHome}/matugen/gtk4.css'

        [templates.ghostty]
        input_path = '${config.xdg.dataHome}/matugen/ghostty'
        output_path = '${config.xdg.configHome}/ghostty/themes/matugen'
        post_hook = 'pkill -SIGUSR2 ghostty'
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
        "matugen/gtk.css".text = builtins.readFile ./gtk.css.mustache;
        "matugen/ghostty".text = builtins.readFile ./ghostty.mustache;
      };
    };
  };
}
