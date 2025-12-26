{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mpv
      pkgs.syncplay
    ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^mpv'';
        workspace = "main";
        fullscreen = true;
      }
      {
        appId = ''^syncplay'';
        workspace = "main";
        floating = true;
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
      ".config/mpv/mpv.conf".text =
        let
          package = pkgs.nih.catppuccin.mpv { src = cfgSources.catppuccin-mpv; };
          palette = cfgStyle.palette;
          theme = builtins.readFile "${package}/${palette.variant}/${palette.accent}.conf";
        in
        ''
          ${theme}
        '';
    };
  };
}
