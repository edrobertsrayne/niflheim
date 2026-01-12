_: {
  flake.modules.homeManager.ghostty = {
    pkgs,
    lib,
    ...
  }: {
    programs.ghostty = {
      enable = true;
      settings = {
        env = ["TERM=xterm-256color"];
        background-opacity = 0.8;
        theme = "matugen";
        window-padding-x = 8;
        window-padding-y = 8;
        window-padding-balance = true;
        confirm-close-surface = false;
        resize-overlay = "never";
        gtk-toolbar-style = "flat";
        cursor-style = "block";
        cursor-style-blink = false;
        scrollback-limit = 10000;
        keybind = [
          "shift+insert=paste_from_clipboard"
          "control+insert=copy_to_clipboard"
          "super+control+shift+alt+arrow_down=resize_split:down,100"
          "super+control+shift+alt+arrow_up=resize_split:up,100"
          "super+control+shift+alt+arrow_left=resize_split:left,100"
          "super+control+shift+alt+arrow_right=resize_split:right,100"
        ];
      };
    };

    xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      terminal-exec = {
        enable = true;
        settings.default = ["ghostty.desktop"];
      };
    };
  };
}
