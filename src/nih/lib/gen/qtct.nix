lib:
let
  formatColor = alpha: hexString: "#${alpha}${builtins.substring 1 (-1) hexString}";
  concatColors = colors: lib.strings.concatStringsSep ", " colors;
in
{

  mkColors =
    palette:
    let
      baseColors = concatColors [
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.surface1)
        (formatColor "ff" palette.overlay2)
        (formatColor "ff" palette.surface2)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.surface1)
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.base)
        (formatColor "ff" palette.overlay2)
        (formatColor "ff" palette.blue)
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.sapphire)
        (formatColor "ff" palette.red)
        (formatColor "ff" palette.surface2)
        (formatColor "ff" palette.text)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.text)
        (formatColor "80" palette.text)
      ];
      disabledColors = concatColors [
        (formatColor "ff" palette.overlay2)
        (formatColor "ff" palette.surface1)
        (formatColor "ff" palette.overlay2)
        (formatColor "ff" palette.surface2)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.surface1)
        (formatColor "ff" palette.overlay1)
        (formatColor "ff" palette.subtext1)
        (formatColor "ff" palette.overlay1)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.base)
        (formatColor "ff" palette.subtext0)
        (formatColor "ff" palette.sky)
        (formatColor "ff" palette.overlay1)
        (formatColor "ff" palette.teal)
        (formatColor "ff" palette.maroon)
        (formatColor "ff" palette.surface2)
        (formatColor "ff" palette.subtext1)
        (formatColor "ff" palette.surface0)
        (formatColor "ff" palette.subtext1)
        (formatColor "80" palette.subtext1)
      ];
    in
    ''
      [ColorScheme]
      active_colors=${baseColors}
      disabled_colors=${disabledColors}
      inactive_colors=${baseColors}
    '';
}
