{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        alejandra
        gh
        statix
        deadnix
        just
        inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      ];
    };
    formatter = pkgs.alejandra;
  };
}
