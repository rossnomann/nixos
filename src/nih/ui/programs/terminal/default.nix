{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUi = cfg.ui;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.alacritty ];
    nih = {
      ui.x11.wm.windowRules = [
        {
          windowClass = "Alacritty";
          spawnOnTag = "alacritty";
        }
      ];
      user.home.file = {
        ".config/alacritty/alacritty.toml".text =
          let
            fontMonospace = cfgUi.style.fonts.monospace;
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
