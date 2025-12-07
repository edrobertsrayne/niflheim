{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.hyprland = {pkgs, ...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    home-manager.users.${username}.imports = [
      inputs.self.modules.homeManager.hyprland
    ];
  };

  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.enable = true;
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    imports = with inputs.self.modules.homeManager; [
      xdg
      waybar
      walker
      swayosd
      hyprlock
      hypridle
      hyprpaper
      gtk
      swaync
      matugen
    ];

    programs = {
      firefox.enable = true;
    };
  };
}
