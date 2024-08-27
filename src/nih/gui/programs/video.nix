{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
  cfgUser = cfg.user;
in
{
  options.nih.gui.programs.video.mpv.theme.package = lib.mkOption {
    internal = true;
    type = lib.types.package;
  };
  config = lib.mkIf cfg.enable {
    nih.gui.programs.video.mpv.theme.package = pkgs.stdenvNoCC.mkDerivation {
      pname = "catppuccin-mpv";
      version = npins.catppuccin-mpv.revision;
      src = npins.catppuccin-mpv;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        find themes/*.conf -type f -exec sed -i "s/^background-color=.*$/background-color=\'#000000\'/g" {} +
        cp -a themes/* $out
        runHook postInstall
      '';
    };
    environment.systemPackages = [
      pkgs.mpv
      pkgs.kdePackages.kdenlive
      pkgs.syncplay
    ];
    home-manager.users.${cfgUser.name} = {
      xdg = {
        configFile."mpv/mpv.conf".source = "${cfgGui.programs.video.mpv.theme.package}/${cfgPalette.variant}/${cfgPalette.accent}.conf";
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
  };
}
