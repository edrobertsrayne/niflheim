_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      # Terminal tagging
      windowrule = [
        "tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)"

        # Browser tagging
        "tag +chromium-based-browser, class:(Google-chrome|Chromium|Brave-browser|Microsoft-edge|vivaldi|Helium)"
        "tag +firefox-based-browser, class:(firefox|zen-alpha|LibreWolf)"

        # Tiling for chromium browsers (fixes --app flag bug)
        "tile, tag:chromium-based-browser"

        # Browser opacity
        "opacity 1 0.85, tag:chromium-based-browser"
        "opacity 1 0.85, tag:firefox-based-browser"

        # Terminal opacity
        "opacity 0.6, tag:terminal"

        # Floating window tag system
        "float, tag:floating-window"
        "center, tag:floating-window"
        "size 900 625, tag:floating-window"

        # Auto-tag floating windows
        "tag +floating-window, class:(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|com.niflheim.niflheim|About|TUI.float|waypaper|org.gnome.Nautilus)"
        "tag +floating-window, class:(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), title:^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)"

        # Calculator
        "float, class:org.gnome.Calculator"

        # Media applications (no transparency for video quality)
        "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
      ];

      windowrulev2 = [
        # Video site opacity exceptions (full opacity for video quality)
        "opacity 1.0 1.0,initialTitle:((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home)"

        # System utilities
        "float,class:^(cliphist)$"
        "float,class:^(hyprpolkitagent)$"
        "float,class:^(gcr-prompter)$"
        "float,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
      ];

      # Layer rules
      layerrule = [
        "noanim, walker"
      ];
    };
  };
}
