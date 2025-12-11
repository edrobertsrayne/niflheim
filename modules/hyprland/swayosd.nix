_: {
  flake.modules.homeManager.hyprland = {
    services.swayosd = {
      enable = true;
    };
  };
}
