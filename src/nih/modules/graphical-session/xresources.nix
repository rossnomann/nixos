{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgGraphicalSession = cfg.graphicalSession;
  xrdb = pkgs.xorg.xrdb;
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.units."xrdb-merge.service" = {
      name = "xrdb-merge.service";
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      text = ''
        [Service]
        ExecStart=${xrdb}/bin/xrdb -merge /etc/X11/Xresources
        Type=simple

        [Unit]
        Requires=graphical-session.target
        After=graphical-session.target
      '';
    };
    environment.etc."X11/Xresources".text =
      let
        colors = cfgStyle.palette.colors;
        gen = lib.nih.gen.xresources;
      in
      gen.mkXresources {
        xcursor = gen.mkXcursor {
          size = cfgStyle.cursors.size;
          theme = cfgStyle.cursors.name;
        };
        xft = gen.mkXft { dpi = cfgGraphicalSession.dpi; };
        colors = gen.mkColors {
          background = colors.base;
          foreground = colors.text;
          black = colors.surface1;
          blackBold = colors.surface2;
          red = colors.red;
          redBold = colors.red;
          green = colors.green;
          greenBold = colors.green;
          yellow = colors.yellow;
          yellowBold = colors.yellow;
          blue = colors.blue;
          blueBold = colors.blue;
          magenta = colors.pink;
          magentaBold = colors.pink;
          cyan = colors.teal;
          cyanBold = colors.teal;
          white = colors.subtext1;
          whiteBold = colors.subtext0;
        };
      };
    environment.systemPackages = [ xrdb ];
  };
}
