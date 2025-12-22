{lib, ...}: {
  options.flake.niflheim.monitoring = with lib; {
    serverAddress = mkOption {
      type = types.str;
      default = "thor";
      description = "Hostname of monitoring server (Tailscale MagicDNS)";
    };
  };
}
