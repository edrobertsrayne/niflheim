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
      ]);

    boot = {
      loader.grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    programs.nix-ld.enable = true;

    users.users.${username}.extraGroups = ["dialout"];
  };

  flake.modules.homeManager.freya = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      starship
      utilities
      neovim
      obsidian
      spicetify
      python
      ghostty
      cava
      vscodium
    ];

    programs = {
      firefox.enable = true;
      zathura.enable = true;
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
      vesktop.enable = true;
    };

    home.packages = with pkgs; [
      bambu-studio
      zotero
    ];
  };
}
