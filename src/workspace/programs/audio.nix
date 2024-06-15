{ config, pkgs, ... }:
{
  environment.sessionVariables.LV2_PATH = "$HOME/.nix-profile/lib/lv2";
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      # composing/recording
      pkgs.ardour
      pkgs.easyeffects
      pkgs.guitarix
      pkgs.hydrogen
      pkgs.musescore
      pkgs.ocenaudio

      # playing
      pkgs.cplay-ng
      pkgs.deadbeef

      # settings
      pkgs.helvum
      pkgs.pavucontrol

      # plugins
      pkgs.calf
      pkgs.caps
      pkgs.distrho
      pkgs.eq10q
      pkgs.gxplugins-lv2
      pkgs.kapitonov-plugins-pack
      pkgs.lsp-plugins
      pkgs.neural-amp-modeler-lv2
      pkgs.noise-repellent
      pkgs.oxefmsynth
      pkgs.rkrlv2
      pkgs.tap-plugins
      pkgs.x42-avldrums
      pkgs.x42-plugins
    ];
  };
}
