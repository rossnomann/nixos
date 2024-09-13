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
      pkgs.unrar
      pkgs.xarchiver
    ];
    nih.xdg.mime.archives = "xarchiver.desktop";
    nih.x11.wm.windowRules = [
      {
        windowClass = "xarchiver";
        spawnOnTag = "secondary";
      }
    ];
  };
}
