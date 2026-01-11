_: {
  flake.modules.nixos.plymouth = {pkgs, ...}: {
    boot = {
      plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = with pkgs; [
          nixos-bgrt-plymouth
        ];
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      loader.timeout = 0;
    };
  };
}
