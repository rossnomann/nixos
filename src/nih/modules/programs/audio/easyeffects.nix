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
  options.nih.programs.audio.easyeffects = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.audio.easyeffects.package ];
    nih.programs.audio.easyeffects.package = pkgs.easyeffects;
    nih.windowRules = [
      {
        x11Class = "easyeffects";
        waylandAppId = "com.github.wwmm.easyeffects";
        useWorkspace = "audio";
      }
    ];
  };
}
