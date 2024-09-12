{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam ];
  nih.x11.wm.windowRules = [
    {
      windowClass = "steam";
      spawnFloating = true;
      spawnOnTag = "steam";
    }
  ];
}
