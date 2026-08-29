{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  package = pkgs.nih.xkb;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "custom_lat,custom_cyr";
      extraLayouts = {
        custom_lat = {
          description = "Custom latin";
          symbolsFile = "${package}/share/X11/xkb/symbols/custom_lat";
        };
        custom_cyr = {
          description = "Custom cyrillic";
          symbolsFile = "${package}/share/X11/xkb/symbols/custom_cyr";
        };
      };
    };
  };
}
