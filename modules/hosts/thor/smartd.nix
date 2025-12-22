_: {
  flake.modules.nixos.thor = _: {
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        wall.enable = true;
        test = false;
      };
    };
  };
}
