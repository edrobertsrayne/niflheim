_: {
  flake.modules.nixos.loki = {pkgs, ...}: {
    services.getty.autologinUser = "ed";

    environment.loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec ${pkgs.cage}/bin/cage -- ${pkgs.retroarch}/bin/retroarch --fullscreen
      fi
    '';

    environment.systemPackages = with pkgs; [
      cage
      xorg.xset # For disabling screensaver if needed
    ];

    hardware.graphics.enable = true;
  };
}
