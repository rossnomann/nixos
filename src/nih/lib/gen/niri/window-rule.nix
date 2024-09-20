lib: kdl: args: props: layout:
let
  mkRule =
    nodeName:
    {
      appId ? null,
      atStartup ? null,
      isActive ? null,
      isFocused ? null,
      isActiveInColumn ? null,
      title ? null,
    }:
    kdl.mkNode nodeName {
      props = [
        (props.mkString "app-id" appId)
        (props.mkBool "at-startup" atStartup)
        (props.mkBool "is-active" isActive)
        (props.mkBool "is-focused" isFocused)
        (props.mkBool "is-active-in-column" isActiveInColumn)
        (props.mkString "title" title)
      ];
    };
  mkMatch = mkRule "match";
  mkExclude = mkRule "exclude";
  mkDefaultColumnWidth = preset: kdl.mkNode "default-column-width" { children = [ preset ]; };
in
{
  mk =
    {
      matches ? [ ],
      excludes ? [ ],
      blockOutFrom ? null,
      border ? null,
      clipToGeometry ? null,
      defaultColumnWidth ? null,
      drawBorderWithBackground ? null,
      focusRing ? null,
      geometryCornerRadius ? null,
      maxHeight ? null,
      maxWidth ? null,
      minHeight ? null,
      minWidth ? null,
      opacity ? null,
      openFullscreen ? null,
      openMaximized ? null,
      openOnOutput ? null,
      openOnWorkspace ? null,
      variableRefreshRate ? null,
    }:
    let
      matchRules = map mkMatch matches;
      excludeRules = map mkExclude excludes;
    in
    kdl.mkNode "window-rule" {
      children =
        matchRules
        ++ excludeRules
        ++ [
          (args.mkString "block-out-from" blockOutFrom)
          (lib.mapNullable layout.mkBorder border)
          (args.mkBool "clip-to-geometry" clipToGeometry)
          (lib.mapNullable mkDefaultColumnWidth defaultColumnWidth)
          (args.mkBool "draw-border-with-background" drawBorderWithBackground)
          (lib.mapNullable layout.mkFocusRing focusRing)
          (args.mkInteger "geometry-corner-radius" geometryCornerRadius)
          (args.mkInteger "max-height" maxHeight)
          (args.mkInteger "min-height" minHeight)
          (args.mkInteger "max-width" maxWidth)
          (args.mkInteger "min-width" minWidth)
          (args.mkFloat "opacity" opacity)
          (args.mkBool "open-fullscreen" openFullscreen)
          (args.mkBool "open-maximized" openMaximized)
          (args.mkString "open-on-output" openOnOutput)
          (args.mkString "open-on-workspace" openOnWorkspace)
          (args.mkBool "variable-refresh-rate" variableRefreshRate)
        ];
    };
}
