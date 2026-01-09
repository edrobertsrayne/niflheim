_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: let
    settings = ''
      [Settings]
      gtk-theme-name=adw-gtk3
      gtk-icon-theme-name=Papirus-Dark
      gtk-font-name=Adwaita Sans 11
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
    '';
  in {
    home.packages = with pkgs; [
      adw-gtk3
      bibata-cursors
      papirus-folders
      papirus-icon-theme
    ];
    xdg.configFile = {
      "gtk-3.0/settings.ini".text = settings;
      "gtk-4.0/settings.ini".text = settings;
    };
  };
}
