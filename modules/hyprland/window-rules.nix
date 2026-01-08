_: {
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      # Terminal tagging
      windowrule = [
        "match:class (Alacritty|kitty|com.mitchellh.ghostty), tag +terminal"

        # Browser tagging
        "match:class (Google-chrome|Chromium|Brave-browser|Microsoft-edge|vivaldi|Helium), tag +chromium-based-browser"
        "match:class (firefox|zen-alpha|LibreWolf), tag +firefox-based-browser"

        # Tiling for chromium browsers (fixes --app flag bug)
        "match:tag chromium-based-browser, tile on"

        # Browser opacity
        "match:tag chromium-based-browser, opacity 1 0.85"
        "match:tag firefox-based-browser, opacity 1 0.85"

        # Floating window tag system
        "match:tag floating-window, float on"
        "match:tag floating-window, center on"
        "match:tag floating-window, size 900 625"

        # Auto-tag floating windows
        "match:class (blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|com.niflheim.niflheim|About|TUI.float|waypaper|org.gnome.Nautilus), tag +floating-window"
        "match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus) match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files), tag +floating-window"

        # Calculator
        "match:class org.gnome.Calculator, float on"

        # Media applications (no transparency for video quality)
        "match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$, opacity 1 1"

        # Video site opacity exceptions (full opacity for video quality)
        "match:initial_title ((?i)(?:[a-z0-9-]+\\.)*youtube\\.com_/|app\\.zoom\\.us_/wc/home), opacity 1.0 1.0"

        # System utilities
        "match:class ^(cliphist)$, float on"
        "match:class ^(hyprpolkitagent)$, float on"
        "match:class ^(gcr-prompter)$, float on"

        # Picture-in-Picture
        "match:title ^(Picture-in-Picture)$, float on, pin on"
      ];

      # Layer rules
      layerrule = [
        "no_anim 1, match:namespace walker"
      ];
    };
  };
}
