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
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.alacritty ];
    nih = {
      user.home.file = {
        ".config/alacritty/alacritty.toml".text =
          let
            fontMonospace = cfgStyle.fonts.monospace;
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
      x11.wm.windowRules = [
        {
          windowClass = "Alacritty";
          spawnOnTag = "alacritty";
        }
      ];
    };
  };
}
