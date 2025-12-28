_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        alejandra
        gh
        statix
        deadnix
        just
      ];
    };
    formatter = pkgs.alejandra;
  };
}
