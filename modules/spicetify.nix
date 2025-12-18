{inputs, ...}: {
  flake.modules.homeManager.spicetify = {pkgs, ...}: let
    spkPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = [inputs.spicetify-nix.homeManagerModules.spicetify];

    programs = {
      spicetify = {
        enable = true;
        enabledExtensions = with spkPkgs.extensions; [
          adblock
          hidePodcasts
          shuffle
          keyboardShortcut
        ];
      };
    };

    home.packages = [pkgs.spicetify-cli];

    wayland.windowManager.hyprland.settings = {
      bindd = [
        "SUPER SHIFT, S, Spotify, exec, spotify"
      ];
      windowrule = [
        "workspace name:spotify, class:spotify"
      ];
    };
  };
}
