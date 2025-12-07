{inputs, ...}: {
  flake.modules.homeManager.hyprlock = {config, ...}: {
    programs.hyprlock = {
      enable = true;
      settings = {
        source = ["${config.xdg.configHome}/hypr/colors.conf"];
        background = [
          {
            monitor = "";
            path = "$image";
            blur_passes = 3;
            blur_size = 4;
            contrast = 0.8;
            brightness = 0.6;
            vibrancy = 0.2;
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "300, 50";
            outline_thickness = 2;

            dots_size = 0.2;
            dots_spacing = 0.35;
            dots_center = true;

            outer_color = "$primary";
            inner_color = "$surface_container_high";
            font_color = "$on_surface";

            fade_on_empty = false;
            placeholder_text = "Enter password...";

            position = "0, -200";
            halign = "center";
            valign = "center";
          }
        ];

        label = with inputs.self.niflheim; [
          # Time
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
            color = "$on_surface";
            font_size = 96;
            font_family = "${fonts.sans.name}";
            font_weight = 500;

            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          # Date
          {
            monitor = "";
            text = ''cmd[update:60000] echo "$(date +"%A, %B %d")"'';
            color = "$on_surface_variant";
            font_size = 24;
            font_family = "${fonts.sans.name}";
            font_weight = 500;

            position = "0, 120";
            halign = "center";
            valign = "center";
          }
        ];
      };
      sourceFirst = true;
    };
  };
}
