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
  options.nih.programs.audio.plugins.lv2 = {
    enable = lib.mkEnableOption "LV2 plugins";
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.audio.plugins.lv2.enable) {
    environment.sessionVariables =
      let
        makeLv2Path = pkg: "${pkg}/lib/lv2";
        pluginsLv2 = [
          pkgs.airwindows-lv2
          pkgs.calf
          pkgs.drumgizmo
          pkgs.guitarix
          pkgs.gxplugins-lv2
          pkgs.lsp-plugins
          pkgs.noise-repellent
          pkgs.sfizz
          pkgs.x42-avldrums
        ];
      in
      {
        LV2_PATH = lib.concatStringsSep ":" (map makeLv2Path pluginsLv2);
      };
  };
}
