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
    environment.systemPackages = [ pkgs.ardour ];
    nih.user.home.file = {
      ".config/ardour8/my-dark-ardour-8.12.colors".source = ./resources/catppuccin-ardour.colors;
    };
    nih.graphicalSession.windowRules = [
      {
        appId = ''^Ardour'';
        workspace = "audio";
      }
    ];
  };
}
