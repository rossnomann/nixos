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
  options.nih.programs.audio.deadbeef = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.audio.deadbeef.package ];
    nih.programs.audio.deadbeef.package = pkgs.deadbeef;
    nih.windowRules = [
      {
        x11Class = "deadbeef";
        waylandAppId = "deadbeef";
        useWorkspace = "audio";
      }
    ];
  };
}
