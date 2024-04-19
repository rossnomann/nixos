{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.telegram-desktop ];
    xdg.mimeApps =
      let
        assoc = {
          "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        };
      in
      {
        associations.added = assoc;
        defaultApplications = { };
      };
  };
}
