{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.alacritty ];
    nih = {
      gui.x11.wm.windowRules = [
        {
          windowClass = "Alacritty";
          spawnOnTag = "alacritty";
        }
      ];
      user.home.file = {
        ".config/alacritty/alacritty.toml".text =
          let
            fontMonospace = cfgGui.style.fonts.monospace;
          in
          ''
            import = ["${npins.catppuccin-alacritty}/catppuccin-${cfgPalette.variant}.toml"]
            [cursor.style]
            blinking = "Always"
            shape = "Beam"
            [font]
            size = ${builtins.toString fontMonospace.defaultSize}
            [font.normal]
            family = "${fontMonospace.family}"
            [scrolling]
            history = 100000
            [window]
            decorations = "None"
            [window.padding]
            x = 20
            y = 10
          '';
      };
    };
  };
}
