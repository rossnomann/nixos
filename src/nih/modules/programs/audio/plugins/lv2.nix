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
          pkgs.calf
          pkgs.eq10q
          pkgs.gxplugins-lv2
          pkgs.guitarix
          pkgs.kapitonov-plugins-pack
          pkgs.lsp-plugins
          pkgs.noise-repellent
          pkgs.x42-avldrums
        ];
      in
      {
        LV2_PATH = lib.concatStringsSep ":" (map makeLv2Path pluginsLv2);
      };
  };
}
