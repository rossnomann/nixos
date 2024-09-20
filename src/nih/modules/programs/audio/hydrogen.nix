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
  options.nih.programs.audio.hydrogen = {
    enable = lib.mkEnableOption "hydrogen";
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.audio.hydrogen.enable) {
    environment.systemPackages = [ cfgPrograms.audio.hydrogen.package ];
    nih.programs.audio.hydrogen.package = pkgs.hydrogen;
    nih.windowRules = [
      {
        x11Class = "hydrogen";
        waylandAppId = "hydrogen";
        useWorkspace = "audio";
      }
    ];
  };
}
