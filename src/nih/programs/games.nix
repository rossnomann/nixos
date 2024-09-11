{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam ];
  nih.ui.x11.wm.windowRules = [
    {
      windowClass = "steam";
      spawnFloating = true;
      spawnOnTag = "steam";
    }
  ];
}
