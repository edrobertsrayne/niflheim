_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER SHIFT, L, Logout, exec, wlogout"
    ];

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      style = ''
        @import "colors.css";
        * {
          background-image: none;
          box-shadow: none;
        }

        window {
          background-color: @surface_dim;
        }

        button {
          border-radius: 24px;
          border: none;
          color: @on_surface;
          background-color: @surface_container_low;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          margin: 8px;
        }

        button:hover {
          background-color: @primary;
          color: @on_primary;
        }

        button:focus, button:active {
          background-color: @primary_container;
          color: @on_primary_container;
        }

        #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
        }

        #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
        }

        #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
      '';
    };
  };
}
