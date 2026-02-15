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
  inherit (pkgs) xrdb;
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
        inherit (cfgStyle.palette) colors;
        mkClassResource =
          className: resourceName: value:
          "${className}.${resourceName}: ${toString value}";
        mkClassResources =
          className: attrs: builtins.mapAttrs (name: value: mkClassResource className name value) attrs;
        mkGlobalResource = resourceName: value: "*${resourceName}: ${value}";
        mkGlobalResources = attrs: builtins.mapAttrs (name: value: mkGlobalResource name value) attrs;
        attrsToString = attrs: lib.strings.concatStringsSep "\n" (lib.attrsets.attrValues attrs);
        mkXcursor =
          { size, theme }:
          mkClassResources "Xcursor" {
            inherit
              size
              theme
              ;
          };
        mkXft =
          {
            antialias ? 1,
            autohint ? 0,
            dpi,
            lcdfilter ? "lcddefault",
            hinting ? 1,
            hintstyle ? "hintfull",
            rgba ? "rgb",
          }:
          mkClassResources "Xft" {
            inherit
              antialias
              autohint
              dpi
              lcdfilter
              hinting
              hintstyle
              rgba
              ;
          };
        mkColors =
          {
            background,
            foreground,
            black,
            blackBold,
            red,
            redBold,
            green,
            greenBold,
            yellow,
            yellowBold,
            blue,
            blueBold,
            magenta,
            magentaBold,
            cyan,
            cyanBold,
            white,
            whiteBold,
          }:
          mkGlobalResources {
            inherit background foreground;
            color0 = black;
            color8 = blackBold;
            color1 = red;
            color9 = redBold;
            color2 = green;
            color10 = greenBold;
            color3 = yellow;
            color11 = yellowBold;
            color4 = blue;
            color12 = blueBold;
            color5 = magenta;
            color13 = magentaBold;
            color6 = cyan;
            color14 = cyanBold;
            color7 = white;
            color15 = whiteBold;
          };
        mkXresources =
          {
            xcursor,
            xft,
            colors,
          }:
          lib.strings.concatStringsSep "\n" [
            (attrsToString xcursor)
            (attrsToString xft)
            (attrsToString colors)
            ""
          ];
      in
      mkXresources {
        xcursor = mkXcursor {
          inherit (cfgStyle.cursors) size;
          theme = cfgStyle.cursors.name;
        };
        xft = mkXft { inherit (cfgGraphicalSession) dpi; };
        colors = mkColors {
          inherit (colors)
            red
            green
            yellow
            blue
            ;
          background = colors.base;
          foreground = colors.text;
          black = colors.surface1;
          blackBold = colors.surface2;
          redBold = colors.red;
          greenBold = colors.green;
          yellowBold = colors.yellow;
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
