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
