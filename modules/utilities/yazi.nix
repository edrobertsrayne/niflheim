_: {
  flake.modules.homeManager.utilities = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "yy";
    };
  };
}
