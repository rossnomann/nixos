{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      pkgs.ardour
      pkgs.cplay-ng
      pkgs.deadbeef
      pkgs.guitarix
      pkgs.gxplugins-lv2
      pkgs.hydrogen
      pkgs.ocenaudio
      pkgs.tuxguitar
    ];
    xdg.dataFile."applications/tuxguitar.desktop".source = ./resources/tuxguitar.desktop;
  };
}
