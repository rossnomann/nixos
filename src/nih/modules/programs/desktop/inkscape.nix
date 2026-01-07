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
    environment.systemPackages = [ pkgs.inkscape ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^org\\.inkscape\\.Inkscape'';
        workspace = "main";
      }
    ];
  };
}
