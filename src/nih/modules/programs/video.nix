{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kdePackages.kdenlive
      pkgs.mpv
      pkgs.syncplay
    ];
    nih.x11.wm.windowRules = [
      {
        windowClass = "kdenlive";
        spawnOnTag = "main";
      }
      {
        windowClass = "mpv";
        spawnFullscreen = true;
        spawnOnTag = "main";
      }
      {
        windowClass = ".syncplay-wrapped";
        spawnFloating = true;
        spawnOnTag = "secondary";
      }
    ];
    nih.xdg.mime =
      let
        entry = "mpv.desktop";
      in
      {
        audio = entry;
        videos = entry;
      };
    nih.user.home.file = {
      ".config/mpv/mpv.conf".source =
        let
          package = pkgs.nih.catppuccin.mpv;
          palette = cfgStyle.palette;
        in
        "${package}/${palette.variant}/${palette.accent}.conf";
    };
  };
}
