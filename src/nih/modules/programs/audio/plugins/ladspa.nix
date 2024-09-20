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
  options.nih.programs.audio.plugins.ladspa = {
    enable = lib.mkEnableOption "LADSPA plugins";
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.audio.plugins.ladspa.enable) {
    environment.sessionVariables =
      let
        makeLadspaPath = pkg: "${pkg}/lib/ladspa";
        pluginsLadspa = [
          pkgs.caps
          pkgs.tap-plugins
        ];
      in
      {
        LADSPA_PATH = lib.concatStringsSep ":" (map makeLadspaPath pluginsLadspa);
      };
  };
}
