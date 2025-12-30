{inputs, ...}: let
  inherit (inputs.self.lib.hosts) nixosSystem;
  inherit (inputs.self.niflheim.user) username;
in {
  flake = {
    nixosConfigurations.freya = nixosSystem "x86_64-linux" "freya";

    modules.nixos.freya = {
      imports =
        [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ]
        ++ (with inputs.self.modules.nixos; [
          wireless
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
        loader.grub = {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
        binfmt.emulatedSystems = ["aarch64-linux"];
      };

      users.users.${username}.extraGroups = ["dialout"];
    };

    modules.homeManager.freya = {pkgs, ...}: {
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
  };
}
