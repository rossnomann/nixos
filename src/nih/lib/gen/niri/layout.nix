lib: kdl: args:
let
  mkRing =
    name:
    {
      activeColor ? null,
      inactiveColor ? null,
      off ? false,
      width ? null,
    }:
    kdl.mkNode name {
      children = [
        (args.mkString "active-color" activeColor)
        (args.mkString "inactive-color" inactiveColor)
        (kdl.mkNodeBool "off" off)
        (args.mkInteger "width" width)
      ];
    };
  mkBorder = mkRing "border";
  mkFocusRing = mkRing "focus-ring";
  mkPresetFixed = value: args.mkFloat "fixed" value;
  mkPresetProportion = value: args.mkFloat "proportion" value;
  mkDefaultColumnWidth = preset: kdl.mkNode "default-column-width" { children = [ preset ]; };
  mkPresetColumnWidths = children: kdl.mkNode "preset-column-widths" { inherit children; };
  mkPresetWindowHeights = children: kdl.mkNode "preset-window-heights" { inherit children; };
  mkStruts =
    {
      bottom ? 0,
      left ? 0,
      right ? 0,
      top ? 0,
    }:
    kdl.mkNode "struts" {
      children = [
        (args.mkInteger "bottom" bottom)
        (args.mkInteger "left" left)
        (args.mkInteger "right" right)
        (args.mkInteger "top" top)
      ];
    };
in
{
  inherit
    mkBorder
    mkFocusRing
    mkPresetFixed
    mkPresetProportion
    ;
  mk =
    {
      border ? null,
      centerFocusedColumn ? null,
      defaultColumnWidth ? null,
      focusRing ? null,
      gaps ? null,
      presetColumnWidths ? null,
      struts ? null,
    }:
    kdl.mkNode "layout" {
      children = [
        (lib.mapNullable mkBorder border)
        (args.mkString "center-focused-column" centerFocusedColumn)
        (lib.mapNullable mkDefaultColumnWidth defaultColumnWidth)
        (lib.mapNullable mkFocusRing focusRing)
        (args.mkInteger "gaps" gaps)
        (lib.mapNullable mkPresetColumnWidths presetColumnWidths)
        (lib.mapNullable mkStruts struts)
      ];
    };
}
