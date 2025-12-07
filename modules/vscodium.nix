_: {
  flake.modules.homeManager.vscodium = {pkgs, ...}: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
