_: {
  flake.modules.nixos.thor = {pkgs, ...}: let
    checkScript = pkgs.writeShellScript "check-unclean-boot" ''
      # Check if there was a previous boot
      if ! ${pkgs.systemd}/bin/journalctl --list-boots | grep -q '\-1'; then
        echo "First boot, skipping unclean boot check"
        exit 0
      fi

      # Check if previous boot had a clean shutdown
      if ! ${pkgs.systemd}/bin/journalctl -b -1 | grep -q "Reached target System Shutdown"; then
        ${pkgs.systemd}/bin/systemd-cat -t unclean-boot -p warning echo "UNCLEAN BOOT DETECTED: Previous boot did not shut down cleanly (possible power loss)"
        echo "unclean" > /var/lib/boot-status/status
      else
        echo "clean" > /var/lib/boot-status/status
      fi
    '';
  in {
    systemd.services.unclean-boot-detector = {
      description = "Detect unclean boot after power loss";
      wantedBy = ["multi-user.target"];
      after = ["systemd-journald.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${checkScript}";
        StateDirectory = "boot-status";
      };
    };
  };
}
