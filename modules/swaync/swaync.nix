{inputs, ...}: {
  flake.modules.homeManager.swaync = _: {
    # TODO: fix notification icons and MPRIS album art
    # TODO: add wireless, bluetooth and other relevant buttons

    wayland.windowManager.hyprland.settings.bindd = [
      "SUPER, N, Toggle notification centre, exec, swaync-client -t -sw"
    ];

    services.swaync = {
      enable = true;
      settings = {
        widgets = ["title" "notifications" "mpris" "volume"];
        image-visibility = "when-available";
        mpris = {
          image-visibility = "when-available";
          image-size = 96;
        };
      };
      style = with inputs.self.niflheim;
        ''
          @import "colors.css";

          * {
            font-family: "${fonts.sans.name}", "${fonts.monospace.name} Propo";
            font-size: 14px;
            all: unset;
            transition: 200ms;
          }
        ''
        + (builtins.readFile ./style.css);
    };
  };
}
