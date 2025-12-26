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
    environment.systemPackages = [ pkgs.transmission_4-gtk ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^transmission'';
        workspace = "main";
      }
    ];
    nih.xdg.mime.torrents = "transmission-gtk.desktop";
  };
}
