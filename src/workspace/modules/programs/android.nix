{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.android-tools pkgs.scrcpy ];
  };
}
