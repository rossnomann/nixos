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
  options.nih.programs.audio.vamp = {
    enable = lib.mkEnableOption "VAMP plugins host";
    host.package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.audio.vamp.enable) {
    environment.sessionVariables = {
      VAMP_PATH = "$HOME/.local/lib/vamp";
    };
    environment.systemPackages = [ cfgPrograms.audio.vamp.host.package ];
    nih.programs.audio.vamp.host.package = pkgs.sonic-visualiser;
    nih.windowRules = [
      {
        x11Class = "sonic\\\\-visualiser";
        waylandAppId = "sonic-visualiser";
        useWorkspace = "audio";
      }
    ];
  };
}
