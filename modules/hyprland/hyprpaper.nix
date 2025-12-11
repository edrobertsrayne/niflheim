_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    services.hyprpaper.enable = true;
    home.packages = with pkgs; [
      waypaper
      hyprpaper
    ];

    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      show_path_in_tooltip = True
      backend = hyprpaper
      fill = fill
      sort = name
      color = #ffffff
      subfolders = False
      all_subfolders = False
      show_hidden = False
      show_gifs_only = False
      zen_mode = False
      post_command = matugen image $wallpaper
      number_of_columns = 3
      use_xdg_state = True
    '';
  };
}
