{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.sessionVariables =
      let
        makeLv2Path = pkg: "${pkg}/lib/lv2";
        makeLadspaPath = pkg: "${pkg}/lib/ladspa";
        pluginsLv2 = [
          pkgs.calf
          pkgs.distrho
          pkgs.eq10q
          pkgs.gxplugins-lv2
          pkgs.guitarix
          pkgs.kapitonov-plugins-pack
          pkgs.lsp-plugins
          pkgs.neural-amp-modeler-lv2
          pkgs.noise-repellent
          pkgs.rkrlv2
          pkgs.x42-avldrums
          pkgs.x42-plugins
        ];
        pluginsLadspa = [
          pkgs.caps
          pkgs.tap-plugins
        ];
      in
      {
        LADSPA_PATH = lib.concatStringsSep ":" (map makeLadspaPath pluginsLadspa);
        LV2_PATH = lib.concatStringsSep ":" (map makeLv2Path pluginsLv2);
      };
    environment.systemPackages = [
      pkgs.ardour
      pkgs.deadbeef
      pkgs.easyeffects
      pkgs.helvum
      pkgs.hydrogen
      pkgs.lame
      pkgs.pavucontrol
    ];
    nih.x11.wm.windowRules = [
      {
        windowClass = "ardour-8.4.0";
        spawnOnTag = "audio";
      }
      {
        windowClass = "ardour_ardour";
        spawnOnTag = "audio";
      }
      {
        windowClass = "deadbeef";
        spawnOnTag = "audio";
      }
      {
        windowClass = "easyeffects";
        spawnOnTag = "audio";
      }
      {
        windowClass = "helvum";
        spawnOnTag = "audio";
      }
      {
        windowClass = "hydrogen";
        spawnOnTag = "audio";
      }
      {
        windowClass = "pavucontrol";
        spawnOnTag = "audio";
      }
    ];
  };
}
