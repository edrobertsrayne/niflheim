{inputs, ...}: let
  inherit (inputs.self.settings.user) username;
in {
  flake.modules.nixos.docker = {
    virtualisation.docker = {
      enable = true;
    };
    users.users.${username}.extraGroups = ["docker"];
  };
}
