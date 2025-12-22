_: {
  flake.modules.nixos.thor = _: {
    services.journald.extraConfig = ''
      Storage=persistent
      SystemMaxUse=1G
      RuntimeMaxUse=100M
    '';
  };
}
