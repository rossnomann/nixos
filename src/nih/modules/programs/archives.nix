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
    nih.windowRules = [
      {
        x11Class = "xarchiver";
        waylandAppId = "xarchiver";
        useWorkspace = "secondary";
      }
    ];
  };
}
