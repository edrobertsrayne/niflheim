{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings = let
      monitor-event-handler = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.monitor-event-handler;
    in {
      exec-once = [
        "waypaper --restore"
        monitor-event-handler
      ];
      bindd = [
        "SUPER SHIFT, W, Wallpaper browser, exec, waypaper --folder $HOME/Pictures/Wallpapers"
        "SUPER ALT, W, Random wallpaper, exec, waypaper --random --folder $HOME/Pictures/Wallpapers"
      ];
    };

    home.packages = [
      (pkgs.waypaper.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "anufrievroman";
          repo = "waypaper";
          rev = "622c978f4ae099866d29033aad8248aaa9458d9b";
          hash = "sha256-BtWdi8c3x7EafxEsGL7+jbXQWtSxYq7pJsNW+XwcUVc=";
        };
      }))
      pkgs.hyprpaper
    ];

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
      };
    };

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
