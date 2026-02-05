{inputs, ...}: let
  inherit (inputs.self.niflheim) user;
  initialHashedPassword = "$y$j9T$vueRmYTLFOtT6Q3jiCH8M/$oTfJQqYfgnDprn/nBxRHgpz90EpDVDtAiV7Aqvx.U95";
in {
  flake.modules.nixos.user = {
    pkgs,
    lib,
    ...
  }: {
    users = {
      mutableUsers = false;
      users.${user.username} = {
        isNormalUser = true;
        description = user.fullname;
        inherit initialHashedPassword;
        extraGroups = ["wheel" "networkmanager"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0EYKmro8pZDXNyT5NiBZnRGhQ/5HlTn5PJEWRawUN1"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjO/+Q0fcuPJlilQNFfTbxG78ov3owvJW66poCTZVy4"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdf/364Rgul97UR6vn4caDuuxBk9fUrRjfpMsa4sfam" # ed@freya
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINW5tgMzPytrfk373U9EfL5ol6No9lIelF6dL8ZYSe0B" # ed@thor
        ];
        packages = with pkgs; [
          vim
          git
          htop
        ];
      };

      users.root = {inherit initialHashedPassword;};
    };

    security.sudo = {
      execWheelOnly = true;
      wheelNeedsPassword = lib.mkDefault true;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };
}
