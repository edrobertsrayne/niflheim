_: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      statix
      deadnix
    ];

    programs.ruff = {
      enable = true;
      settings = {
        line-length = 100;
        select = ["E" "F" "I"];
      };
    };

    programs.nvf = {
      settings = {
        vim = {
          withPython3 = true;
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            enableDAP = true;

            css.enable = true;
            bash.enable = true;
            markdown.enable = true;
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
            python = {
              enable = true;
              format = {
                enable = true;
                type = ["ruff"];
              };
              lsp = {
                enable = true;
                servers = ["pyright"];
              };
            };
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
