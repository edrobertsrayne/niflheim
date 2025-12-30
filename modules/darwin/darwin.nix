{inputs, ...}: {
  flake.modules.darwin.darwin = with inputs.self.modules.darwin; {
    imports = [
      home-manager
      nix
    ];
    system = {
      primaryUser = "ed";
      defaults = {
        dock = {
          autohide = true;
          orientation = "bottom";
          tilesize = 48;
          magnification = false;
          show-recents = false;
          launchanim = false;
          show-process-indicators = true;
          mineffect = "scale";
        };
        finder = {
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          _FXShowPosixPathInTitle = true;
          QuitMenuItem = true;
        };
        NSGlobalDomain = {
          _HIHideMenuBar = false;
          AppleKeyboardUIMode = 3;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          AppleInterfaceStyle = "Dark";
        };
        screencapture = {
          location = "~/Pictures/Screenshots";
          type = "png";
        };
      };
    };
    security.pam.services = {
      sudo_local = {
        reattach = true;
        touchIdAuth = true;
      };
    };
  };
}
