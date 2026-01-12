{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings.bindd = let
      launch-menu = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.launch-menu;
    in [
      "SUPER SHIFT, SPACE, Main menu, exec, ${launch-menu}"
    ];
  };

  perSystem = {pkgs, ...}: let
    selfPkgs = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    packages = {
      launch-menu = pkgs.writeShellApplication {
        name = "launch-menu";
        runtimeInputs = with pkgs; [
          bash
          walker
          hyprpicker
          hyprlock
          systemd
          nh
          fastfetch
          procps # provides pgrep/pkill
          selfPkgs.launch-presentation-terminal
          selfPkgs.take-screenshot
          selfPkgs.launch-webapp
          selfPkgs.launch-editor
          selfPkgs.show-keybindings
        ];
        text = builtins.readFile ./launch-menu.sh;
      };

      show-keybindings = pkgs.writeShellApplication {
        name = "show-keybindings";
        runtimeInputs = with pkgs; [
          hyprland
          jq
          walker
          libxkbcommon
          gawk
          gnused
          coreutils
        ];
        text = builtins.readFile ./show-keybindings.sh;
      };

      monitor-event-handler = pkgs.writeShellApplication {
        name = "monitor-event-handler";
        runtimeInputs = with pkgs; [
          socat
          hyprland
          hyprpaper
          waypaper
          procps
        ];
        text = builtins.readFile ./monitor-event-handler.sh;
      };
    };
  };
}
