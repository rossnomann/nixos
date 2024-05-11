{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name}.home = {
    file.".local/bin/screenshot".source = ./resources/screenshot;
    packages = [
      pkgs.shotgun
      pkgs.slop
    ];
  };
}
