{ config, lib, ... }:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
in
{
  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
    ];
    console =
      let
        getColor = value: builtins.substring 1 (-1) value;
        palette = cfgPalette.colors;
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
