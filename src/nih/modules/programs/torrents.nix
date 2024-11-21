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
    nih.windowRules = [
      {
        x11Class = "transmission\\\\-gtk";
        waylandAppId = "transmission-gtk";
        useWorkspace = "main";
      }
    ];
    nih.xdg.mime.torrents = "transmission-gtk.desktop";
  };
}
