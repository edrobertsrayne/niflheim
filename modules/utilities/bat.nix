_: {
  flake.modules.homeManager.utilities = {pkgs, ...}: {
    programs.bat = {
      enable = true;
      themes = {
        tokyonight = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd";
            sha256 = "4zfkv3egdWJ/GCWUehV0MAIXxsrGT82Wd1Qqj1SCGOk=";
          };
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
      };
      config = {
        theme = "tokyonight";
      };
    };
    home.shellAliases = {
      cat = "bat";
    };
  };
}
