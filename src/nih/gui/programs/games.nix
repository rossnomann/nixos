{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam ];
  nih.gui.x11.wm.windowRules = [
    {
      windowClass = "steam";
      spawnFloating = true;
      spawnOnTag = "steam";
    }
  ];
}
