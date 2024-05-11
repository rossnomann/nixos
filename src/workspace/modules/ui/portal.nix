{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
