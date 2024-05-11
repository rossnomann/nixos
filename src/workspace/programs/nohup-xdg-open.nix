{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      (pkgs.writeShellScriptBin "nohup-xdg-open" ''
        ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
      '')
    ];
  };
}
