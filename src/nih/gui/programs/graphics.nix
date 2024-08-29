{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
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
    nih.xdg.mime.images = "com.interversehq.qView.desktop";
  };
}
