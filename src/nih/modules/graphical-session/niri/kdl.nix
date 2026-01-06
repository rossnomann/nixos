lib:
let
  kdl = lib.nih.kdl;
  on = kdl.mkNode "on" { };
  off = kdl.mkNode "off" { };
  mkBindsWorkspace =
    idx: name:
    let
      nameString = kdl.types.mkString name;
    in
    [
      (kdl.mkNodeWithChildren "Mod+${idx}" [
        (kdl.mkNodeWithArgs "focus-workspace" [ nameString ])
      ])
      (kdl.mkNodeWithChildren "Mod+Shift+${idx}" [
        (kdl.mkNodeWithArgs "move-window-to-workspace" [ nameString ])
      ])
    ];
  mkRing =
    name:
    {
      enabled ? null,
      width ? null,
      activeColor ? null,
      inactiveColor ? null,
      urgentColor ? null,
    }:
    let
      mkColor =
        colorType: value: kdl.mkNodeWithArgs ''${colorType}-color'' [ (kdl.types.mkString value) ];
      mkWidth = x: kdl.mkNodeWithArgs "width" [ (kdl.types.mkFloat width) ];
    in
    kdl.mkNodeWithChildren name [
      (
        if enabled == null then
          null
        else if enabled then
          on
        else
          off
      )
      (lib.mapNullable mkWidth width)
      (lib.mapNullable (mkColor "active") activeColor)
      (lib.mapNullable (mkColor "inactive") inactiveColor)
      (lib.mapNullable (mkColor "urgent") urgentColor)
    ];
  mkAnimations =
    {
      enabled,
      slowdown ? null,
    }:
    let
      mkSlowdown = x: kdl.mkNodeWithArgs "slowdown" [ (kdl.types.mkFloat x) ];
    in
    kdl.mkNodeWithChildren "animations" [
      (if enabled then on else off)
      (lib.mapNullable mkSlowdown slowdown)
    ];
  mkBorder = data: mkRing "border" data;
  mkBackdropColor = x: kdl.mkNodeWithArgs "backdrop-color" [ (kdl.types.mkString x) ];
  mkFocusRing = data: mkRing "focus-ring" data;
  mkBinds = kdl.mkNodeWithChildren "binds";
  mkBindSpawn =
    { keys, command }:
    kdl.mkNodeWithChildren keys [
      (kdl.mkNodeWithArgs "spawn" [ command ])
    ];
  mkBindsWorkspaces =
    workspaces:
    let
      indexes = map builtins.toString (lib.range 1 (lib.lists.length workspaces));
    in
    lib.lists.flatten (lib.lists.zipListsWith mkBindsWorkspace indexes workspaces);
  mkCursor =
    { xcursorTheme, xcursorSize }:
    kdl.mkNodeWithChildren "cursor" [
      (kdl.mkNodeWithArgs "xcursor-theme" [ (kdl.types.mkString xcursorTheme) ])
      (kdl.mkNodeWithArgs "xcursor-size" [ (kdl.types.mkInteger xcursorSize) ])
    ];
  mkEnvironment =
    let
      mkVar = name: value: kdl.mkNodeWithArgs name [ (kdl.types.mkString value) ];
    in
    vars: kdl.mkNodeWithChildren "environment" (lib.attrsets.mapAttrsToList mkVar vars);
  mkHotkeyOverlay =
    { skipAtStartup }:
    kdl.mkNodeWithChildren "hotkey-overlay" [
      (if skipAtStartup then (kdl.mkNode "skip-at-startup" { }) else null)
    ];
  mkInclude = path: kdl.mkNodeWithArgs "include" [ (kdl.types.mkString path) ];
  mkInput =
    {
      focusFollowsMouse ? null,
      keyboard ? null,
      touchpad ? null,
      warpMouseToFocus ? null,
    }:
    let
      mkFocusFollowsMouse =
        {
          maxScrollAmount ? null,
        }:
        kdl.mkNodeWithProps "focus-follows-mouse" {
          "max-scroll-amount" = (kdl.types.mkString maxScrollAmount);
        };
      mkKeyboard =
        {
          xkb ? null,
          trackLayout ? null,
        }:
        let
          mkXkb =
            {
              layout ? null,
              options ? null,
              variant ? null,
              file ? null,
            }:
            let
              mkString = name: value: (kdl.mkNodeWithArgs name [ (kdl.types.mkString value) ]);
            in
            kdl.mkNodeWithChildren "xkb" [
              (lib.mapNullable (mkString "layout") layout)
              (lib.mapNullable (mkString "options") options)
              (lib.mapNullable (mkString "variant") variant)
              (lib.mapNullable (mkString "file") file)
            ];
          mkTrackLayout = x: kdl.mkNodeWithArgs "track-layout" [ (kdl.types.mkString x) ];
        in
        kdl.mkNodeWithChildren "keyboard" [
          (lib.mapNullable mkXkb xkb)
          (lib.mapNullable mkTrackLayout trackLayout)
        ];
      mkFlag = name: value: if value == true then kdl.mkNode name { } else null;
      mkTouchpad =
        {
          dwt ? null,
          dwtp ? null,
          middleEmulation ? null,
          scrollMethod ? null,
          tap ? null,
        }:
        let
          mkScrollMethod = x: kdl.mkNodeWithArgs "scroll-method" [ (kdl.types.mkString x) ];
        in
        kdl.mkNodeWithChildren "touchpad" [
          (mkFlag "dwt" dwt)
          (mkFlag "dwtp" dwtp)
          (mkFlag "middle-emulation" middleEmulation)
          (lib.mapNullable mkScrollMethod scrollMethod)
          (mkFlag "tap" tap)
        ];
    in
    kdl.mkNodeWithChildren "input" [
      (lib.mapNullable mkFocusFollowsMouse focusFollowsMouse)
      (lib.mapNullable mkKeyboard keyboard)
      (lib.mapNullable mkTouchpad touchpad)
      (mkFlag "warp-mouse-to-focus" warpMouseToFocus)
    ];
  mkLayout =
    {
      border ? null,
      centerFocusedColumn ? null,
      defaultColumnWidth ? null,
      focusRing ? null,
      gaps ? null,
      insertHint ? null,
      presetColumnWidths ? null,
      presetWindowHeights ? null,
      struts ? null,
    }:
    let
      mkCenterFocusedColumn = x: kdl.mkNodeWithArgs "center-focused-column" [ (kdl.types.mkString x) ];
      mkGaps = x: kdl.mkNodeWithArgs "gaps" [ (kdl.types.mkFloat x) ];
      mkInsertHint =
        { color }:
        kdl.mkNodeWithChildren "insert-hint" [
          (kdl.mkNodeWithArgs "color" [ (kdl.types.mkString color) ])
        ];
      mkSize =
        let
          mkItem =
            x:
            let
              k = builtins.elemAt x 0;
              v = builtins.elemAt x 1;
            in
            kdl.mkNodeWithArgs k [ (kdl.types.mkFloat v) ];
        in
        name: values: kdl.mkNodeWithChildren name (map mkItem values);
      mkStruts =
        {
          bottom,
          top,
          left,
          right,
        }:
        kdl.mkNodeWithChildren "struts" [
          (kdl.mkNodeWithArgs "bottom" [ (kdl.types.mkInteger bottom) ])
          (kdl.mkNodeWithArgs "top" [ (kdl.types.mkInteger top) ])
          (kdl.mkNodeWithArgs "left" [ (kdl.types.mkInteger left) ])
          (kdl.mkNodeWithArgs "right" [ (kdl.types.mkInteger right) ])
        ];
    in
    kdl.mkNodeWithChildren "layout" [
      (lib.mapNullable mkBorder border)
      (lib.mapNullable mkCenterFocusedColumn centerFocusedColumn)
      (lib.mapNullable (mkSize "default-column-width") [ defaultColumnWidth ])
      (lib.mapNullable mkFocusRing focusRing)
      (lib.mapNullable mkGaps gaps)
      (lib.mapNullable mkInsertHint insertHint)
      (lib.mapNullable (mkSize "preset-column-widths") presetColumnWidths)
      (lib.mapNullable (mkSize "preset-window-heights") presetWindowHeights)
      (lib.mapNullable mkStruts struts)
    ];
  mkOutput =
    let
      mkHotCorners =
        { enabled }: (kdl.mkNodeWithChildren "hot-corners" [ (if enabled then on else off) ]);
      mkMode = x: kdl.mkNodeWithArgs "mode" [ (kdl.types.mkString x) ];
      mkPosition =
        { x, y }:
        kdl.mkNodeWithProps "position" {
          x = kdl.types.mkInteger x;
          y = kdl.types.mkInteger y;
        };
      mkScale = x: kdl.mkNodeWithArgs "scale" [ (kdl.types.mkFloat x) ];
    in
    {
      name,
      backdropColor ? null,
      focusAtStartup ? false,
      mode ? null,
      position ? null,
      scale ? null,
      hotCorners ? null,
    }:
    kdl.mkNode "output" {
      args = [ (kdl.types.mkString name) ];
      children = [
        (lib.mapNullable mkBackdropColor backdropColor)
        (kdl.mkNodeOptional focusAtStartup "focus-at-startup" { })
        (lib.mapNullable mkMode mode)
        (lib.mapNullable mkPosition position)
        (lib.mapNullable mkScale scale)
        (lib.mapNullable mkHotCorners hotCorners)
      ];
    };
  mkOverview =
    {
      backdropColor ? null,
    }:
    kdl.mkNodeWithChildren "overview" [
      (lib.mapNullable mkBackdropColor backdropColor)
    ];
  mkRecentWindows =
    { enabled }: kdl.mkNodeWithChildren "recent-windows" [ (if enabled then on else off) ];
  mkScreenshotPath =
    path:
    kdl.mkNodeWithArgs "screenshot-path" [
      (if path == null then "null" else kdl.types.mkString path)
    ];
  mkSpawnAtStartup = commands: map (item: kdl.mkNodeWithArgs "spawn-at-startup" [ item ]) commands;
  mkSpawnCommand = args: lib.strings.concatStringsSep " " (map (x: ''"${x}"'') args);
  mkWindowRule =
    let
      mkMatch =
        {
          appId ? null,
          atStartup ? null,
          isActive ? null,
          isActiveInColumn ? null,
          isFloating ? null,
          isFocused ? null,
          isUrgent ? null,
          isWindowCastTarget ? null,
          title ? null,
        }:
        kdl.mkNodeWithProps "match" {
          "app-id" = kdl.types.mkString appId;
          "at-startup" = kdl.types.mkBool atStartup;
          "is-active" = kdl.types.mkBool isActive;
          "is-active-in-column" = kdl.types.mkBool isActiveInColumn;
          "is-floating" = kdl.types.mkBool isFloating;
          "is-focused" = kdl.types.mkBool isFocused;
          "is-urgent" = kdl.types.mkBool isUrgent;
          "is-window-cast-target" = kdl.types.mkBool isWindowCastTarget;
          "title" = kdl.types.mkString title;
        };
      mkOpacity = x: kdl.mkNodeWithArgs "opacity" [ (kdl.types.mkFloat x) ];
      mkBool = name: value: kdl.mkNodeWithArgs name [ (kdl.types.mkBool value) ];
      mkOpenBool = name: mkBool "open-${name}";
      mkOpenOnWorkspace = x: kdl.mkNodeWithArgs "open-on-workspace" [ (kdl.types.mkString x) ];
      mkShadow = { enabled }: kdl.mkNodeWithChildren "shadow" [ (if enabled then on else off) ];
      mkSize = name: value: kdl.mkNodeWithArgs name [ (kdl.types.mkInteger value) ];
    in
    {
      matches ? null,
      border ? null,
      clipToGeometry ? null,
      drawBorderWithBackground ? null,
      maxHeight ? null,
      maxWidth ? null,
      minHeight ? null,
      minWidth ? null,
      opacity ? null,
      openFloating ? null,
      openFullscreen ? null,
      openMaximized ? null,
      openMaximizedToEdges ? null,
      openOnWorkspace ? null,
      shadow ? null,
      tiledState ? null,
    }:
    kdl.mkNodeWithChildren "window-rule" [
      (lib.mapNullable mkMatch matches)
      (lib.mapNullable mkBorder border)
      (lib.mapNullable (mkBool "clip-to-geometry") clipToGeometry)
      (lib.mapNullable (mkBool "draw-border-with-background") drawBorderWithBackground)
      (lib.mapNullable (mkSize "max-height") maxHeight)
      (lib.mapNullable (mkSize "max-width") maxWidth)
      (lib.mapNullable (mkSize "min-height") minHeight)
      (lib.mapNullable (mkSize "min-width") minWidth)
      (lib.mapNullable mkOpacity opacity)
      (lib.mapNullable (mkOpenBool "floating") openFloating)
      (lib.mapNullable (mkOpenBool "fullscreen") openFullscreen)
      (lib.mapNullable (mkOpenBool "maximized") openMaximized)
      (lib.mapNullable (mkOpenBool "maximized-to-edges") openMaximizedToEdges)
      (lib.mapNullable mkOpenOnWorkspace openOnWorkspace)
      (lib.mapNullable mkShadow shadow)
      (lib.mapNullable (mkBool "tiled-state") tiledState)
    ];
  mkWorkspace =
    {
      name,
      openOnOutput ? null,
    }:
    let
      mkOpenOnOutput = x: kdl.mkNodeWithArgs "open-on-output" [ (kdl.types.mkString x) ];
    in
    kdl.mkNode "workspace" {
      args = [ (kdl.types.mkString name) ];
      children = [
        (lib.mapNullable mkOpenOnOutput openOnOutput)
      ];
    };
  mkWorkspaces =
    data:
    let
      items = lib.attrsets.mapAttrsToList (_: lib.trivial.id) data;
      sorted = lib.lists.sortOn (x: x.order) items;
    in
    map (
      {
        name,
        openOnOutput ? null,
        ...
      }:
      mkWorkspace { inherit name openOnOutput; }
    ) sorted;
in
{
  mkConfig =
    data:
    kdl.mkDocument (
      (mkWorkspaces data.workspaces)
      ++ (mkSpawnAtStartup data.spawnAtStartup)
      ++ (map mkInclude data.includes)
      ++ [
        (mkAnimations data.animations)
        (mkBinds (
          (map (
            x:
            mkBindSpawn {
              keys = builtins.elemAt x 0;
              command = mkSpawnCommand (builtins.elemAt x 1);
            }
          ) data.bindsSpawn)
          ++ mkBindsWorkspaces data.bindsWorkspaces
        ))
        (mkCursor data.cursor)
        (mkEnvironment data.environment)
        (mkHotkeyOverlay data.hotkeyOverlay)
        (mkInput data.input)
        (mkLayout data.layout)
        (mkOverview data.overview)
        (kdl.mkNode "prefer-no-csd" { })
        (mkRecentWindows data.recentWindows)
        (mkScreenshotPath data.screenshotPath)
      ]
      ++ (map mkOutput data.outputs)
      ++ (map mkWindowRule data.windowRules)
    );
}
