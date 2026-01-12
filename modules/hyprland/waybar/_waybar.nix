{inputs, ...}: {
  flake.modules.homeManager.hyprland = let
    inherit (inputs.self.niflheim) fonts;
  in
    {
      pkgs,
      lib,
      ...
    }: {
      wayland.windowManager.hyprland.settings.exec-once = ["waybar"];

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            reload_style_on_change = true;
            layer = "top";
            position = "top";
            spacing = 0;
            margin-top = 12;
            margin-left = 8;
            margin-right = 8;

            modules-left = [
              "hyprland/workspaces"
              "mpris"
              "hyprland/submap"
            ];
            modules-center = ["clock"];
            modules-right = [
              "pulseaudio"
              "network"
              "battery"
            ];

            "hyprland/workspaces" = {
              on-click = "activate";
              sort-by-number = true;
              format = "{icon}";
              format-icons = {
                "spotify" = "󰓇";
              };
              persistent-workspaces = {
                "*" = 5;
              };
            };

            "hyprland/submap" = {
              tooltip = false;
            };

            mpris = {
              format = "󰓇 {artist} - {title}";
              player = "spotify";
              on-click = "playerctl play-pause";
              max-length = 40;
              tooltip-format = "{artist} - {title}";
            };

            tray = {
              icon-size = 18;
              spacing = 10;
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "{icon} {volume}%";
              format-bluetooth-muted = "󰂲";
              format-muted = "󰖁";
              format-icons = {
                headphone = "󰋋";
                hands-free = "󱡒";
                headset = "󰋎";
                phone = "󰄜";
                portable = "󰦧";
                car = "󰄋";
                default = ["󰕿" "󰖀" "󰕾"];
              };
              on-click = "xdg-terminal-exec --app-id=Wiremix -e ${lib.getExe pkgs.wiremix}";
              on-click-right = "${lib.getExe pkgs.pamixer} -t";
            };

            network = {
              format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
              format-wifi = "{icon} {essid}";
              format = "{icon}";
              format-ethernet = "󰀂";
              format-disconnected = "󰤮";
              tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
              tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
              on-click = "xdg-terminal-exec --app-id=com.niflheim.niflheim -e nmtui";
              interval = 3;
            };

            battery = {
              states = {
                warning = 25;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-plugged = "󰚥";
              format-icons = {
                default = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
              };
            };

            bluetooth = {
              format = "";
              format-disabled = "󰂲";
              format-connected = "";
              tooltip-format = "Devices connected: {num_connections}";
              on-click = lib.getExe' pkgs.blueman "blueman";
            };

            clock = {
              format = "{:L%A %B %d %H:%M}";
              format-alt = " {:L%d %B W%V %Y}";
              tooltip = false;
            };

            # cpu = {
            #   interval = 15;
            #   format = " ";
            #   on-click = "xdg-terminal-exec --app-id=com.niflheim.niflheim -e ${lib.getExe pkgs.btop}";
            # };
          };
        };

        style =
          ''
            @import "colors.css";

            * {
              font-family: "${fonts.sans.name}", "${fonts.monospace.name} Propo";
              background-color: transparent;
              color: @on_surface;
              font-size: 14px;

              min-height: 0;
              margin: 0;
              padding: 0;
            }
          ''
          + (builtins.readFile ./waybar.css);
      };
    };
}
