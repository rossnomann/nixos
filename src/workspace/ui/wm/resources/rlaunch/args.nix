{ ui }:
let
  font = ui.font.sansSerif;
  palette = ui.palette;
in
[
  "-f '${font.family}:size=${builtins.toString (font.defaultSize - 2)}'"
  "--color0 '${palette.surface0}'"
  "--color1 '${palette.surface1}'"
  "--color2 '${palette.text}'"
  "--color3 '${palette.text}'"
  "--color4 '${palette.surface0}'"
  "--terminal alacritty"
]
