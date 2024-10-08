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
    nih.windowRules = [
      {
        x11Class = "ardour-8.4.0";
        waylandAppId = "ardour";
        useWorkspace = "audio";
      }
      {
        x11Class = "ardour_ardour";
        waylandAppId = "ardour_ardour";
        useWorkspace = "audio";
      }
    ];
  };
}
