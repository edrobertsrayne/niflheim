_: {
  flake.modules.nixos.greetd = {pkgs, ...}: {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
    };
  };
}
