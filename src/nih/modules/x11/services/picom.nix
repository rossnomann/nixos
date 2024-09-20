{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
  cfgX11 = cfg.x11;
in
{
  config = lib.mkIf (cfg.enable && cfgX11.enable) {
    services.picom = {
      enable = true;

      activeOpacity = 1.0;
      backend = "glx";
      fade = true;
      fadeDelta = 10;
      fadeSteps = [
        2.8e-2
        3.0e-2
      ];
      inactiveOpacity = 1.0;
      menuOpacity = 1.0;
      shadow = false;
      shadowOffsets = [
        (-15)
        (-15)
      ];
      shadowOpacity = 0.75;
      vSync = true;
    };
  };
}
