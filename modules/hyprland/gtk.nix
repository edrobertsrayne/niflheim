_: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    config,
    ...
  }: {
    gtk = {
      enable = true;
      # font.name = fonts.sans.name;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3"; # Use LIGHT theme, redefine colors in gtk.css
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    # Matugen-generated gtk.css with Material Design colors
    xdg.configFile."gtk-3.0/gtk.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/matugen/gtk3.css";
    xdg.configFile."gtk-4.0/gtk.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/matugen/gtk4.css";
  };
}
