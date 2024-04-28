{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name}.home.packages = [
    (pkgs.gimp-with-plugins.override { plugins = [ pkgs.gimpPlugins.gmic ]; })
  ];
}
