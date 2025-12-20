_: {
  # Cursor environment variables moved to ~/.config/uwsm/env
  # See modules/hyprland/uwsm-env.nix
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    # Cursor behavior
    wayland.windowManager.hyprland.settings.cursor = {
      hide_on_key_press = true;
    };

    # Cursor theme package
    home.packages = [pkgs.bibata-cursors];
  };
}
