{inputs, ...}: let
  inherit (inputs.self.niflheim) fonts;
in {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    # Helper to resolve package from dot-separated string path
    getPackage = path: lib.attrByPath (lib.splitString "." path) null pkgs;
  in {
    fonts.fontconfig.enable = true;
    home.packages = [
      (getPackage fonts.serif.package)
      (getPackage fonts.sans.package)
      (getPackage fonts.monospace.package)
      (getPackage fonts.emoji.package)
    ];
  };
}
