{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.video = {
    mpv.theme.package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mpv
      pkgs.kdePackages.kdenlive
      pkgs.syncplay
    ];
    nih = {
      programs.video.mpv.theme.package = pkgs.nih.catppuccin.mpv;
      x11.wm.windowRules = [
        {
          windowClass = "mpv";
          spawnFullscreen = true;
          spawnOnTag = "secondary";
        }
        {
          windowClass = ".syncplay-wrapped";
          spawnFloating = true;
          spawnOnTag = "secondary";
        }
      ];
      xdg.mime =
        let
          entry = "mpv.desktop";
        in
        {
          audio = entry;
          videos = entry;
        };
      user.home.file = {
        ".config/mpv/mpv.conf".source =
          let
            package = cfgPrograms.video.mpv.theme.package;
          in
          "${package}/${cfgStyle.palette.variant}/${cfgStyle.palette.accent}.conf";
      };
    };
  };
}
