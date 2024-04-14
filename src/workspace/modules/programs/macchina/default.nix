{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.macchina ];
  workspace.home.xdg.configFile = {
    "macchina/macchina.toml".source = ./resources/config.toml;
    "macchina/themes/default.toml".source = ./resources/theme.toml;
  };
}
