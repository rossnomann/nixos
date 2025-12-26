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
  options.nih.programs.games = {
    enable = lib.mkEnableOption "games";
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.games.enable) {
    environment.systemPackages = [ pkgs.steam ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^steam'';
        fullscreen = true;
        workspace = "games";
      }
    ];
  };
}
