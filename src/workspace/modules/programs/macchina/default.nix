{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.macchina ];
  home-manager.users.${config.workspace.user.name}.xdg.configFile = {
    "macchina/macchina.toml".source = ./resources/config.toml;
    "macchina/themes/default.toml".source = ./resources/theme.toml;
  };
}
