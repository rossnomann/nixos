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
    environment.systemPackages = [ pkgs.steam ];
    nih.x11.wm.windowRules = [
      {
        windowClass = "steam";
        spawnFloating = true;
        spawnOnTag = "steam";
      }
    ];
  };
}
