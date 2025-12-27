{inputs, ...}: {
  flake.modules.darwin.odin = {
    imports = with inputs.self.modules.darwin; [
      zsh
    ];
  };

  flake.modules.homeManager.odin = {
    imports = with inputs.self.modules.homeManager; [
      utilities
      zsh
      starship
      neovim
      wezterm
    ];

    programs = {
      vscode.enable = true;
    };
  };
}
