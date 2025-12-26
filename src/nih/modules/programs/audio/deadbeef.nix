{
  config,
  lib,
  pkgs20251111,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.audio.deadbeef = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.audio.deadbeef.package ];
    nih.programs.audio.deadbeef.package = pkgs20251111.deadbeef;
    nih.graphicalSession.windowRules = [
      {
        appId = ''^deadbeef'';
        workspace = "secondary";
      }
    ];
  };
}
