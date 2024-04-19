{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mc ];
  home-manager.users.${config.workspace.user.name}.xdg = {
    configFile."mc/ini".source = ./resources/config.ini;
    configFile."mc/mc.ext.ini".source = ./resources/mc.ext.ini;
    dataFile."mc/skins/catppuccin.ini".source = ./resources/catppuccin.ini;
  };
}
