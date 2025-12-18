{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules = {
    nixos.python = {
      programs.nix-ld = {
        enable = true;
      };
      home-manager.users.${username}.imports = [
        inputs.self.modules.homeManager.python
      ];
    };

    homeManager.python = {
      programs = {
        uv.enable = true;
        ruff = {
          enable = true;
          settings = {
            line-length = 100;
            select = ["E" "F" "I"];
          };
        };
        nvf.settings.vim = {
          languages.python = {
            enable = true;
            format = {
              enable = true;
              type = "ruff";
            };
            lsp = {
              enable = true;
              server = "pyright";
            };
            dap.enable = true;
          };
          withPython3 = true;
        };
      };
    };
  };
}
