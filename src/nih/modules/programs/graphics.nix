{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.graphics = {
    gimp = {
      package = lib.mkOption { type = lib.types.package; };
      executable = lib.mkOption { type = lib.types.str; };
    };
    inkscape = {
      package = lib.mkOption { type = lib.types.package; };
      executable = lib.mkOption { type = lib.types.str; };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfgPrograms.graphics.gimp.package
      cfgPrograms.graphics.inkscape.package
      pkgs.exiftool
      pkgs.imagemagick
      pkgs.qview
    ];
    nih.programs.graphics.gimp.executable = "${cfgPrograms.graphics.gimp.package}/bin/gimp";
    nih.programs.graphics.gimp.package = pkgs.gimp-with-plugins.override {
      plugins = [ pkgs.gimpPlugins.gmic ];
    };
    nih.programs.graphics.inkscape.executable = "${cfgPrograms.graphics.inkscape.package}/bin/inkscape";
    nih.programs.graphics.inkscape.package = pkgs.inkscape;
    nih.x11.wm.windowRules = [
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
    nih.xdg.mime.images = "com.interversehq.qView.desktop";
  };
}
