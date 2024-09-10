{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    services.picom = {
      enable = true;

      activeOpacity = 1.0;
      backend = "glx";
      fade = true;
      fadeDelta = 10;
      fadeSteps = [0.028 0.03];
      inactiveOpacity = 1.0;
      menuOpacity = 1.0;
      shadow = false;
      shadowOffsets = [(-15) (-15)];
      shadowOpacity = 0.75;
      vSync = true;
    };
  };
}
