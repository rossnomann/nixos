{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.bat ];
  home-manager.users.${config.workspace.user.name}.xdg.configFile = {
    "bat/config".source = ./resources/config;
    "bat/themes/Catppuccin Mocha.tmTheme".source = ./resources/mocha.tmTheme;
  };
}
