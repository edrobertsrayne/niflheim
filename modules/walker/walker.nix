{inputs, ...}: {
  flake.modules.homeManager.walker = {
    imports = [inputs.walker.homeManagerModules.default];
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
