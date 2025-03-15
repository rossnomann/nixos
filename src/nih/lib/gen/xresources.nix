lib:
let
  mkClassResource =
    className: resourceName: value:
    ''${className}.${resourceName}: ${builtins.toString value}'';
  mkClassResources =
    className: attrs: builtins.mapAttrs (name: value: mkClassResource className name value) attrs;
  mkGlobalResource = resourceName: value: ''*${resourceName}: ${value}'';
  mkGlobalResources = attrs: builtins.mapAttrs (name: value: mkGlobalResource name value) attrs;
  attrsToString = attrs: lib.strings.concatStringsSep "\n" (lib.attrsets.attrValues attrs);
in
{
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
}
