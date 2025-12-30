{inputs, ...}: let
  inherit (inputs.self.lib.hosts) darwinSystem;
in {
  flake = {
    darwinConfigurations.odin = darwinSystem "x86_64-darwin" "odin";

    modules.darwin.odin = {
      imports = with inputs.self.modules.darwin; [
        zsh
      ];
    };

    modules.homeManager.odin = {pkgs, ...}: {
      imports = with inputs.self.modules.homeManager; [
        utilities
        zsh
        starship
        neovim
        wezterm
      ];

      programs = {
        vscode.enable = true;
        ghostty = {
          enable = true;
          package = pkgs.ghostty-bin;
          settings = {
            env = ["TERM=xterm-256color"];
            theme = "nord";
            window-padding-x = 8;
            window-padding-y = 8;
            window-padding-balance = true;
            confirm-close-surface = false;
            resize-overlay = "never";
            cursor-style = "block";
            cursor-style-blink = false;
            scrollback-limit = 10000;
          };
        };
      };
    }; # modules.homeManager.odin
  }; # flake
}
