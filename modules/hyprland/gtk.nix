{inputs, ...}: let
  inherit (inputs.self.niflheim) fonts;
in {
  flake.modules.homeManager.hyprland = {pkgs, ...}: let
    settings = ''
      [Settings]
      gtk-theme-name=adw-gtk3
      gtk-application-prefer-dark-theme = true
      gtk-icon-theme-name=Papirus-Dark
      gtk-cursor-theme-name=Bibata-Modern-Classic
      gtk-cursor-theme-size=24
      gtk-font-name=${fonts.sans.name} 11
      gtk-font-antialiasing=rgba
      gtk-font-rgba-order=rgb
      gtk-font-scaling-factor=1.0
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
