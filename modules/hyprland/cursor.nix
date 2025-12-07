_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    # Environment variables
    wayland.windowManager.hyprland.settings.env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      "XCURSOR_THEME,Bibata-Modern-Classic"
      "HYPRCURSOR_THEME,Bibata-Modern-Classic"
    ];

    # Cursor behavior
    wayland.windowManager.hyprland.settings.cursor = {
      hide_on_key_press = true;
    };

    # Cursor theme package
    home.packages = [pkgs.bibata-cursors];
  };
}
