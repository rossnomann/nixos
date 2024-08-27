{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.discord
      pkgs.slack
      pkgs.telegram-desktop
    ];
    home-manager.users.${config.nih.user.name} = {
      xdg.mimeApps =
        let
          assoc = {
            "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
          };
        in
        {
          associations.added = assoc;
          defaultApplications = assoc;
        };
    };
  };
}
