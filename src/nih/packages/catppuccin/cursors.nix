{
  lib,
  accent,
  variant,
  catppuccin-cursors,
}:
lib.getAttr "${variant}${lib.strings.toSentenceCase accent}" catppuccin-cursors
