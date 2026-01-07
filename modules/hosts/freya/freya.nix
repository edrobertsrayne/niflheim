{inputs, ...}: let
  inherit (inputs.self.niflheim.user) username;
in {
  flake.modules.nixos.freya = {
    imports =
      [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ]
      ++ (with inputs.self.modules.nixos; [
        zsh
        greetd
        audio
        hyprland
        bluetooth
        gaming
        libvirt
        python
        bun
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
      firefox.enable = true;
      zathura.enable = true;
      chromium = {
        enable = true;
      };
      vesktop.enable = true;
      bun.enable = true;
    };

    home.packages = with pkgs; [
      orca-slicer
      zotero
    ];
  };
}
