{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
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
  plugins = pluginsLv2 ++ pluginsLadspa;
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        LADSPA_PATH = lib.concatStringsSep ":" (map makeLadspaPath pluginsLadspa);
        LV2_PATH = lib.concatStringsSep ":" (map makeLv2Path pluginsLv2);
      };
      systemPackages = [
        # composing/recording
        pkgs.ardour
        pkgs.easyeffects

        pkgs.hydrogen

        # encoding
        pkgs.lame

        # playing
        pkgs.deadbeef

        # settings
        pkgs.helvum
        pkgs.pavucontrol
      ] ++ plugins;
    };
    nih.x11.wm.windowRules = [
      {
        windowClass = "deadbeef";
        spawnOnTag = "secondary";
      }
      {
        windowClass = "ardour-8.4.0";
        spawnOnTag = "audio";
      }
      {
        windowClass = "ardour_ardour";
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
