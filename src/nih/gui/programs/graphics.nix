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
    environment.systemPackages = [
      pkgs.exiftool
      (pkgs.gimp-with-plugins.override { plugins = [ pkgs.gimpPlugins.gmic ]; })
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.qview
    ];
    nih = {
      gui.x11.wm.windowRules = [
        {
          windowClass = ".gimp-2.10-wrapped_";
          spawnOnTag = "graphics";
        }
        {
          windowClass = "gmic_qt";
          spawnOnTag = "graphics";
        }
        {
          windowClass = "org.inkscape.Inkscape";
          spawnOnTag = "graphics";
        }
        {
          windowClass = "qview";
          spawnOnTag = "graphics";
        }
      ];
      xdg.mime.images = "com.interversehq.qView.desktop";
    };
  };
}
