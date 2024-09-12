{
  lib,
  accent,
  variant,
  catppuccin-cursors,
}:
lib.getAttr "${variant}${lib.nih.strings.capitalize accent}" catppuccin-cursors
