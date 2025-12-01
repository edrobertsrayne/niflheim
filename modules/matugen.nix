{inputs, ...}: {
  flake.modules.homeManager.matugen = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    xdg.configFile."matugen/config.toml".text = ''
      [config]

      [templates.hyprland]
      input_path = '${config.xdg.dataHome}/matugen/hyprland.conf'
      output_path = '~/.config/hypr/colors.conf'
      post_hook = 'hyprctl reload'
    '';

    xdg.dataFile."matugen/hyprland.conf".text = ''
      <* for name, value in colors *>
      $image = {{image}}
      ''${{name}} = rgba({{value.default.hex_stripped}}ff)
      <* endfor *>
    '';
  };
}
