{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.freya = {
    imports =
      [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ]
      ++ (with inputs.self.modules.nixos; [
        audio
        bluetooth
        common
        gaming
        greetd
        hyprland
        libvirt
        networking
        wireless
        zsh
      ]);

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    users.users.${username}.extraGroups = ["dialout"];

    # enable uv for python development
    programs.nix-ld.enable = true;
  };

  flake.modules.homeManager.freya = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship
      utilities
      neovim
      obsidian
      spicetify
      ghostty
      cava
      vscodium
    ];

    programs = {
      chromium.enable = true;
      firefox.enable = true;
      vesktop.enable = true;
      uv.enable = true;
      zathura.enable = true;
    };

    home.packages = with pkgs; [
      orca-slicer
      zotero
    ];
  };
}
