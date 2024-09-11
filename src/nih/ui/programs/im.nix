{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.discord
      pkgs.slack
      pkgs.telegram-desktop
    ];
    xdg.mime =
      let
        assoc = {
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        };
      in
      {
        addedAssociations = assoc;
        defaultApplications = assoc;
      };
    nih.ui.x11.wm.windowRules = [
      {
        windowClass = "telegram-desktop";
        spawnOnTag = "secondary";
      }
    ];
  };
}
