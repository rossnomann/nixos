{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.macchina ];
    xdg.configFile = {
      "macchina/macchina.toml".source = ./resources/config.toml;
      "macchina/themes/default.toml".source = ./resources/theme.toml;
    };
  };
}
