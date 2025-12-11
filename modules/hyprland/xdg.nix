{inputs, ...}: {
  flake.modules.homeManager.hyprland = {lib, ...}: let
    inherit (inputs.self.niflheim.desktop) browser;

    # Map common browser commands to their .desktop file names
    browserDesktopFile = let
      mapping = {
        firefox = "firefox.desktop";
        chromium = "chromium-browser.desktop";
        brave = "brave-browser.desktop";
        google-chrome = "google-chrome.desktop";
        vivaldi = "vivaldi-stable.desktop";
        opera = "opera.desktop";
        microsoft-edge = "microsoft-edge.desktop";
        epiphany = "org.gnome.Epiphany.desktop";
        qutebrowser = "org.qutebrowser.qutebrowser.desktop";
      };
    in
      mapping.${browser} or "${browser}.desktop";

    # All MIME types that should be handled by the default browser
    browserMimeTypes = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "text/html"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ];
  in {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = lib.genAttrs browserMimeTypes (_: browserDesktopFile);
      };
    };
  };
}
