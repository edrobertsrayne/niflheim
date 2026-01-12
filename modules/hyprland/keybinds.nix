{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.self.niflheim.desktop) launcher;
    launch-browser = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.launch-browser;
    # show-keybindings = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.show-keybindings;
  in {
    wayland.windowManager.hyprland.settings = {
      bindd =
        [
          # Window management
          "SUPER, W, Close window, killactive"
          "SUPER, Q, Close window, killactive"
          "SUPER, T, Toggle floating, togglefloating"
          "SUPER SHIFT, F, Fullscreen, fullscreen"
          "SUPER, P, Pseudo tiling mode, pseudo"
          "SUPER CTRL, F, Fullscreen all monitors, fullscreenstate, 0 2"
          "SUPER, J, Toggle split direction, togglesplit"

          # Applications
          "SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec"
          "SUPER SHIFT, B, Browser, exec, ${launch-browser}"
          "SUPER SHIFT ALT, B, Private browser, exec, ${launch-browser} --private"
          # "SUPER, SPACE, App launcher, exec, ${launcher}"
          "SUPER SHIFT, E, File manager, exec, uwsm-app -- ${lib.getExe pkgs.nautilus} --new-window"
          "SUPER SHIFT, W, Wallpaper browser, exec, waypaper --folder $HOME/Pictures/Wallpapers"
          # "SUPER ALT, W, Random wallpaper, exec, waypaper --random --folder $HOME/Pictures/Wallpapers"
          # "SUPER, K, Show keybindings, exec, ${show-keybindings}"

          # Close all windows
          "CTRL ALT, Delete, Close all windows, exec, hyprctl clients -j | ${lib.getExe pkgs.jq} -r '.[].address' | xargs -I {} hyprctl dispatch closewindow address:{}"

          # Workspace navigation
          "SUPER, Tab, Next workspace, workspace, e+1"
          "SUPER SHIFT, Tab, Previous workspace, workspace, e-1"
          "SUPER CTRL, Tab, Last workspace, workspace, previous"

          # Window focus (directional)
          "SUPER, left, Focus left, movefocus, l"
          "SUPER, right, Focus right, movefocus, r"
          "SUPER, up, Focus up, movefocus, u"
          "SUPER, down, Focus down, movefocus, d"

          # Window cycling (Alt-Tab)
          "ALT, Tab, Next window, cyclenext"
          "ALT SHIFT, Tab, Previous window, cyclenext, prev"

          # Window swap (directional)
          "SUPER SHIFT, left, Swap left, swapwindow, l"
          "SUPER SHIFT, right, Swap right, swapwindow, r"
          "SUPER SHIFT, up, Swap up, swapwindow, u"
          "SUPER SHIFT, down, Swap down, swapwindow, d"

          # Window resize
          "SUPER, equal, Grow window right, resizeactive, 40 0"
          "SUPER, minus, Grow window left, resizeactive, -40 0"
          "SUPER SHIFT, equal, Grow window down, resizeactive, 0 40"
          "SUPER SHIFT, minus, Grow window up, resizeactive, 0 -40"

          # Window grouping (tabbed containers)
          "SUPER, G, Toggle window group, togglegroup"
          "SUPER ALT, G, Remove from group, moveoutofgroup"
          "SUPER ALT, Tab, Next group window, changegroupactive"
          "SUPER ALT SHIFT, Tab, Previous group window, changegroupactive, b"

          # Move window into group (directional)
          "SUPER ALT, left, Add to group left, moveintogroup, l"
          "SUPER ALT, right, Add to group right, moveintogroup, r"
          "SUPER ALT, up, Add to group up, moveintogroup, u"
          "SUPER ALT, down, Add to group down, moveintogroup, d"

          # Jump to specific window in group (1-4)
          "SUPER ALT, 1, Jump to group window 1, changegroupactive, 0"
          "SUPER ALT, 2, Jump to group window 2, changegroupactive, 1"
          "SUPER ALT, 3, Jump to group window 3, changegroupactive, 2"
          "SUPER ALT, 4, Jump to group window 4, changegroupactive, 3"

          # Keyboard layout toggle
          "SUPER SHIFT, L, Switch keyboard layout, exec, hyprctl switchxkblayout all next"
        ]
        ++ (
          # Dynamic workspace keybinds
          # binds SUPER + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "SUPER, code:1${toString i}, Workspace ${toString ws}, workspace, ${toString ws}"
                "SUPER SHIFT, code:1${toString i}, Move to workspace ${toString ws}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      # Volume and brightness controls (repeating + locked + descriptions)
      bindeld = [
        # Volume controls
        ", XF86AudioRaiseVolume, Volume up, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, Volume down, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, Mute, exec, swayosd-client --output-volume mute-toggle"

        # Brightness controls
        ", XF86MonBrightnessUp, Brightness up, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, Brightness down, exec, swayosd-client --brightness lower"

        # Precise volume adjustments
        "ALT, XF86AudioRaiseVolume, Volume up (precise), exec, swayosd-client --output-volume +1"
        "ALT, XF86AudioLowerVolume, Volume down (precise), exec, swayosd-client --output-volume -1"

        # Precise brightness adjustments
        "ALT, XF86MonBrightnessUp, Brightness up (precise), exec, swayosd-client --brightness +1"
        "ALT, XF86MonBrightnessDown, Brightness down (precise), exec, swayosd-client --brightness -1"
      ];

      # Media controls (locked + descriptions)
      bindld = [
        ", XF86AudioPlay, Play/pause, exec, swayosd-client --playerctl play-pause"
        ", XF86AudioNext, Next track, exec, swayosd-client --playerctl next"
        ", XF86AudioPrev, Previous track, exec, swayosd-client --playerctl previous"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
