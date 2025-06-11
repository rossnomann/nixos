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
      pkgs.pitivi
      pkgs.mpv
      pkgs.syncplay
    ];
    nih.windowRules = [
      {
        x11Class = "mpv";
        waylandAppId = "mpv";
        useWorkspace = "main";
        useFullscreen = true;
      }
      {
        x11Class = "\\\\.pitivi\\\\-wrapped";
        waylandAppId = ".pitivi-wrapped";
        useWorkspace = "main";
      }
      {
        x11Class = "\\\\.syncplay\\\\-wrapped";
        waylandAppId = "syncplay";
        useWorkspace = "secondary";
        useFloating = true;
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
