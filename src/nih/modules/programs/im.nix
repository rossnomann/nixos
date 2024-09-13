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
    nih.x11.wm.windowRules = [
      {
        windowClass = "discord";
        spawnOnTag = "secondary";
      }
      {
        windowClass = "slack";
        spawnOnTag = "secondary";
      }
      {
        windowClass = "telegram-desktop";
        spawnOnTag = "secondary";
      }
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
  };
}
