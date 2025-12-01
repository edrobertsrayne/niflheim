{lib, ...}: {
  options.flake.niflheim.fonts = with lib; {
    serif = {
      package = mkOption {
        type = types.str;
        default = "noto-fonts";
        description = "Package name for serif font";
      };
      name = mkOption {
        type = types.str;
        default = "Noto Serif";
      };
    };
    sans = {
      package = mkOption {
        type = types.str;
        default = "noto-fonts";
        description = "Package name for sans-serif font";
      };
      name = mkOption {
        type = types.str;
        default = "Noto Sans";
      };
    };
    monospace = {
      package = mkOption {
        type = types.str;
        default = "nerd-fonts.jetbrains-mono";
        description = "Package name for monospace font";
      };
      name = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
      };
    };
    emoji = {
      package = mkOption {
        type = types.str;
        default = "noto-fonts-color-emoji";
        description = "Package name for emoji font";
      };
      name = mkOption {
        type = types.str;
        default = "Noto Color Emoji";
      };
    };
  };
}
