{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    lib,
    pkgs,
    ...
  }: let
    show-keybindings = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.show-keybindings;
  in {
    imports = [inputs.walker.homeManagerModules.default];

    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, SPACE, App launcher, exec, walker"
      "SUPER, K, Show keybindings, exec, ${show-keybindings}"
    ];

    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        theme = "matugen";
        force_keyboard_focus = true;
        close_when_open = true;
        disable_mouse = false;
        click_to_close = true;
        global_argument_delimiter = "#";
        exact_search_prefix = "'";
      };
      themes."matugen".style = let
        inherit (inputs.self.niflheim) fonts;
      in
        ''
          * {
            font-family: "${fonts.sans.name}", "${fonts.monospace.name} Propo";
          }
        ''
        + builtins.readFile ./style.css;
    };
  };
}
