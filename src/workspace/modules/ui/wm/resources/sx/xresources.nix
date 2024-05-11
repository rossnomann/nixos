{ theme }:
let
  palette = theme.palette;
in
''
  Xcursor.size: ${builtins.toString theme.cursorTheme.size}
  Xcursor.theme: ${theme.cursorTheme.name}

  Xft.autohint: 0
  Xft.dpi: ${builtins.toString theme.dpi}
  Xft.lcdfilter: lcddefault
  Xft.hintstyle: hintfull
  Xft.hinting: 1
  Xft.antialias: 1
  Xft.rgba: rgb

  *background: ${palette.base}
  *foreground: ${palette.text}

  ! black
  *color0: ${palette.surface1}
  *color8: ${palette.surface2}

  ! red
  *color1: ${palette.red}
  *color9: ${palette.red}

  ! green
  *color2: ${palette.green}
  *color10: ${palette.green}

  ! yellow
  *color3: ${palette.yellow}
  *color11: ${palette.yellow}

  ! blue
  *color4: ${palette.blue}
  *color12: ${palette.blue}

  ! magenta
  *color5: ${palette.pink}
  *color13: ${palette.pink}

  ! cyan
  *color6: ${palette.teal}
  *color14: ${palette.teal}

  ! white
  *color7: ${palette.subtext1}
  *color15: ${palette.subtext0}
''
