{inputs, ...}: let
  inherit (inputs.self.niflheim) ports;
in {
  flake.modules.nixos.nixos = {lib, ...}: {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = lib.mkDefault false;
        MaxAuthTries = 3;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
        Protocol = 2;
        X11Forwarding = false;
        UsePAM = true;
        PermitEmptyPasswords = false;
        ChallengeResponseAuthentication = false;
        KbdInteractiveAuthentication = false;
        UseDns = false;
      };
    };
    networking.firewall.allowedTCPPorts = [ports.ssh];
  };
}
