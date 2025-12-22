_: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      statix
      deadnix
    ];
    programs.nvf = {
      settings = {
        vim = {
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            enableDAP = true;
            nix = {
              enable = true;
              lsp = {
                enable = true;
              };
              format = {
                enable = true;
                type = ["alejandra"];
              };
              extraDiagnostics = {
                enable = true;
                types = ["statix" "deadnix"];
              };
            };
            markdown.enable = true;
            python.enable = true;
            css.enable = true;
            bash.enable = true;
            ts = {
              enable = true;
              lsp.enable = true;
              format = {
                enable = true;
                type = ["biome"];
              };
            };
          };
        };
      };
    };
  };
}
