{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      pkgs.ardour
      pkgs.audacity
      pkgs.cplay-ng
      pkgs.deadbeef
      pkgs.guitarix
      pkgs.gxplugins-lv2
      pkgs.hydrogen
      pkgs.tuxguitar
    ];
    xdg.dataFile."applications/tuxguitar.desktop".source = ./resources/tuxguitar.desktop;
  };
}
