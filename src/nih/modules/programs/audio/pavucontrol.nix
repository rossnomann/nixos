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
  options.nih.programs.audio.pavucontrol = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.audio.pavucontrol.package ];
    nih.programs.audio.pavucontrol.package = pkgs.pavucontrol;
    nih.windowRules = [
      {
        x11Class = "pavucontrol";
        waylandAppId = "org.pulseaudio.pavucontrol";
        useWorkspace = "audio";
      }
    ];
  };
}
