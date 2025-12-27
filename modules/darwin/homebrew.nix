_: {
  flake.modules.darwin.darwin = {
    homebrew = {
      enable = true;
      taps = [
        "homebrew/cask-fonts"
      ];

      brews = [
      ];

      casks = [
        "adobe-connect"
        "adobe-creative-cloud"
        "arduino-ide"
        "balenaetcher"
        "bambu-studio"
        "claude"
        "docker-desktop"
        "github"
        "google-chrome"
        "google-drive"
        "kicad"
        "microsoft-edge"
        "processing"
        "raycast"
        "rectangle"
        "steam"
        "tailscale-app"
        "typora"
        "utm"
        "vlc"
      ];
      onActivation.cleanup = "uninstall";
    };
  };
}
