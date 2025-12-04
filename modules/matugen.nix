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

        [templates.walker]
        input_path = '${config.xdg.dataHome}/matugen/colors.css'
        output_path = '${config.xdg.configHome}/walker/themes/matugen/colors.css'
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
      };
    };
  };
}
