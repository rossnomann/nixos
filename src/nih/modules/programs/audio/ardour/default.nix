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
  options.nih.programs.audio.ardour = {
    enable = lib.mkEnableOption "ardour";
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.audio.ardour.enable) {
    environment.systemPackages = [ cfgPrograms.audio.ardour.package ];
    nih.programs.audio.ardour.package = pkgs.ardour;
    nih.user.home.file = {
      ".config/ardour8/my-dark-ardour-8.11.colors".source = ./resources/catppuccin-ardour.colors;
    };
    nih.windowRules = [
      {
        x11Class = "^ardour\\\\-[\\\\.\\\\d]+$";
        waylandAppId = "ardour";
        useWorkspace = "audio";
        spawnAsType = "Normal";
      }
      {
        x11Class = "ardour_ardour";
        waylandAppId = "ardour_ardour";
        useWorkspace = "audio";
      }
    ];
  };
}
