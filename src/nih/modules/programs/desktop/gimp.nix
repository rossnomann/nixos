{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  package = pkgs.gimp3-with-plugins.override {
    plugins = [ pkgs.gimp3Plugins.gmic ];
  };
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^gimp'';
        workspace = "main";
      }
      {
        appId = ''^fr\\.greyc\\.$'';
        workspace = "main";
      }
    ];
  };
}
