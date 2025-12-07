_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    gtk = {
      enable = true;
      # font.name = fonts.sans.name;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
    };

    xdg.configFile = {
      "gtk-3.0/gtk.css".text = ''@import "colors.css";'';
      "gtk-4.0/gtk.css".text = ''@import "colors.css";'';
    };
  };
}
