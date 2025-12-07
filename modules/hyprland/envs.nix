_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      env = [
        # Toolkit backends
        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland,x11,*"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"

        # XDG specifications
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # Application-specific
        "XCOMPOSEFILE,$HOME/.XCompose"
        "EDITOR,nvim"

        # Firefox
        "MOZ_ENABLE_WAYLAND,1"

        # Chromium & Electron
        "NIXOS_OZONE_WL,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"

        # NVIDIA - Core
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"

        # NVIDIA - Performance & Video Acceleration
        "NVD_BACKEND,direct"
        "__GL_MaxFramesAllowed,1"
        "__GL_VRR_ALLOWED,0"
        "VDPAU_DRIVER,nvidia"
      ];
    };
  };
}
