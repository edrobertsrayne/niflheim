{inputs, ...}: let
  inherit (inputs.self.niflheim) fonts;
in {
  flake.modules.homeManager.hyprland = {pkgs, ...}: let
    settings = ''
      [Settings]
      gtk-theme-name=adw-gtk3-dark
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=${fonts.sans.name} 11
    '';
  in {
    home.packages = with pkgs; [
      adw-gtk3
      bibata-cursors
      papirus-icon-theme
    ];
    xdg.configFile = {
      "gtk-3.0/settings.ini".text =
        settings
        + ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
        '';
      "gtk-4.0/settings.ini".text = settings;
      # TODO: GTK4 font antialisaing using fontconfig
    };
  };
}
