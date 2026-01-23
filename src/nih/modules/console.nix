{ config, lib, ... }:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    boot = {
      initrd.verbose = false;
      kernelParams = [
        "splash"
        "quiet"
        "udev.log_level=3"
      ];
      consoleLogLevel = 3;
    };
    console =
      let
        getColor = value: builtins.substring 1 (-1) value;
        palette = cfgStyle.palette.colors;
      in
      {
        colors = map getColor [
          palette.base
          palette.red
          palette.green
          palette.yellow
          palette.blue
          palette.pink
          palette.teal
          palette.subtext1
          palette.surface2
          palette.red
          palette.green
          palette.yellow
          palette.blue
          palette.pink
          palette.teal
          palette.subtext0
        ];
        earlySetup = true;
      };
  };
}
