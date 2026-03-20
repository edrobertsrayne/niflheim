{inputs, ...}: let
  inherit (inputs.self.settings.user) username;

  # Base system shell configuration
  base = pkgs: {
    programs.zsh.enable = true;
    users.users.${username}.shell = pkgs.zsh;
  };
in {
  flake.modules = {
    nixos.zsh = {pkgs, ...}:
      base pkgs
      // {
        home-manager.users.${username}.imports = [inputs.self.modules.homeManager.zsh];
      };

    darwin.zsh = {pkgs, ...}: base pkgs;

    homeManager.zsh = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
      };
    };
  };
}
