_: {
  # UWSM environment configuration
  # See: https://wiki.hypr.land/Configuring/Environment-variables/
  # UWSM users should use ~/.config/uwsm/env instead of hyprland.conf
  flake.modules.homeManager.hyprland = {
    home.file = {
      ".config/uwsm/env".text = ''
        # Toolkit backends
        export QT_QPA_PLATFORM=wayland;xcb
        export GDK_BACKEND=wayland,x11,*
        export SDL_VIDEODRIVER=wayland
        export CLUTTER_BACKEND=wayland

        # XDG specifications
        export XDG_CURRENT_DESKTOP=Hyprland
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=Hyprland

        # Chromium & Electron
        export NIXOS_OZONE_WL=1
        export ELECTRON_OZONE_PLATFORM_HINT=auto
        export OZONE_PLATFORM=wayland

        # Firefox
        export MOZ_ENABLE_WAYLAND=1

        # Cursor
        export XCURSOR_SIZE=24
        export XCURSOR_THEME=Bibata-Modern-Classic

        # Application-specific
        export XCOMPOSEFILE=$HOME/.XCompose
        export EDITOR=nvim
      '';

      ".config/uwsm/env-hyprland".text = ''
        # Hyprland-specific variables (HYPR* and AQ_*)
        export HYPRCURSOR_SIZE=24
        export HYPRCURSOR_THEME=Bibata-Modern-Classic
      '';

      ".config/codium-flags.conf".text = ''
        --enable-features=UseOzonePlatform,WaylandWindowDecorations
        --ozone-platform=wayland
      '';
    };
  };
}
