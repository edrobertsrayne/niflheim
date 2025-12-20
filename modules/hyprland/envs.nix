_: {
  # Environment variables moved to ~/.config/uwsm/env
  # See modules/hyprland/uwsm-env.nix
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      env = [];
    };
  };
}
