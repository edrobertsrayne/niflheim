_: {
  flake.modules.homeManager.bash = {
    programs.bash.enable = true;
    home.shell.enableBashIntegration = true;
  };
}
