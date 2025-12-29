{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
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
    environment.systemPackages = [ pkgs.alsa-utils ];
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "99999";
      }
    ];
    security.rtkit.enable = true;
    services.pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      audio.enable = true;
      enable = true;
      extraConfig.pipewire."10-clock-rate" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [
            44100
            48000
          ];
        };
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    users.users.${cfgUser.name}.extraGroups = [ "audio" ];
  };
}
