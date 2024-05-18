{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      pkgs.ardour
      pkgs.cplay-ng
      pkgs.deadbeef
      pkgs.easyeffects
      pkgs.guitarix
      pkgs.gxplugins-lv2
      pkgs.helvum
      pkgs.hydrogen
      pkgs.musescore
      pkgs.pavucontrol
      pkgs.ocenaudio
    ];
  };
}
