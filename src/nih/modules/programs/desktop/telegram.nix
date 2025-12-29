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
  options.nih.programs.im.telegram = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.telegram-desktop ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^org\\.telegram\\.desktop'';
        workspace = "secondary";
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
