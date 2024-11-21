{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.im.telegram = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.im.telegram.package ];
    nih.programs.im.telegram.package = pkgs.telegram-desktop;
    nih.windowRules = [
      {
        x11Class = "telegram\\\\-desktop";
        waylandAppId = "org.telegram.desktop";
        useWorkspace = "secondary";
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
