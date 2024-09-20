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
  options.nih.programs.graphics.qview = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.graphics.qview.package ];
    nih.programs.graphics.qview.package = pkgs.qview;
    nih.windowRules = [
      {
        x11Class = "qview";
        waylandAppId = "com.interversehq.qView";
        useWorkspace = "graphics";
      }
    ];
    nih.xdg.mime.images = "com.interversehq.qView.desktop";
  };
}
