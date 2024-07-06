{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      pkgs.mpv
      pkgs.kdePackages.kdenlive
      pkgs.syncplay
    ];
    xdg = {
      configFile."mpv/mpv.conf".source = ./resources/mpv/mpv.conf;
      configFile."mpv/script-opts/stats.conf".source = ./resources/mpv/script-opts/stats.conf;
      mimeApps.defaultApplications =
        let
          defaults = [ "mpv.desktop" ];
        in
        {
          "audio/vnd.wave" = defaults;
          "video/3gpp" = defaults;
          "video/3gpp2" = defaults;
          "video/mp2t" = defaults;
          "video/mp4" = defaults;
          "video/mpeg" = defaults;
          "video/ogg" = defaults;
          "video/quicktime" = defaults;
          "video/webm" = defaults;
          "video/x-matroska" = defaults;
          "video/x-msvideo" = defaults;
          "video/x-ms-wmv" = defaults;
        };
    };
  };
}
