lib:
let
  mkList = items: "[${lib.strings.concatStringsSep ", " items}]";
  mkString = value: "\"${value}\"";
  optBool = value: if value == null then "None" else lib.boolToString value;
  optInt = value: if value == null then "None" else builtins.toString value;
  optString = value: if value == null then "None" else mkString value;
  optValue = value: if value == null then "None" else value;
  mkKeybind = command: modifier: key: value: ''
    (
      command: ${command},
      value: ${mkString value},
      modifier: ${mkList (map mkString modifier)},
      key: ${mkString key}
    )
  '';
  mkWindowRuleBase =
    tags:
    {
      windowClass ? null,
      windowTitle ? null,
      spawnOnTag ? null,
      spawnAsType ? null,
      spawnSticky ? null,
      spawnFullscreen ? null,
      spawnFloating ? null,
    }:
    let
      findTagIndex = value: lib.lists.findFirstIndex (x: x == value) null tags;
      assertTagFound =
        value:
        assert (lib.assertMsg (value != null) "tag ${builtins.toString spawnOnTag} is not found");
        value + 1;
      spawnOnTagInt = if spawnOnTag == null then null else assertTagFound (findTagIndex spawnOnTag);
    in
    ''
      (
        spawn_as_type: ${optValue spawnAsType},
        spawn_floating: ${optBool spawnFloating},
        spawn_fullscreen: ${optBool spawnFullscreen},
        spawn_on_tag: ${optInt spawnOnTagInt},
        spawn_sticky: ${optBool spawnSticky},
        window_class: ${optString windowClass},
        window_title: ${optString windowTitle}
      )
    '';
  mkConfig =
    {
      defaultHeight,
      defaultWidth,
      disableCurrentTagSwap,
      disableTitleDrag,
      disableWindowSnap,
      focusBehaviour,
      focusNewWindows,
      insertBehaviour,
      sloppyMouseFollowsFocus,
      statePath,
      keybind,
      layoutMode,
      layouts,
      modkey,
      mousekey,
      tags,
      windowRules,
    }:
    let
      mkWindowRule = (mkWindowRuleBase tags);
    in
    ''
      #![enable(implicit_some)]
      (
          default_height: ${builtins.toString defaultHeight},
          default_width: ${builtins.toString defaultWidth},
          disable_current_tag_swap: ${optBool disableCurrentTagSwap},
          disable_tile_drag: ${optBool disableTitleDrag},
          disable_window_snap: ${optBool disableWindowSnap},
          focus_behaviour: ${focusBehaviour},
          focus_new_windows: ${optBool focusNewWindows},
          insert_behavior: ${insertBehaviour},
          scratchpad: [],
          sloppy_mouse_follows_focus: ${optBool sloppyMouseFollowsFocus},
          state_path: ${statePath},
          keybind: ${mkList keybind},
          layout_mode: ${layoutMode},
          layouts: ${mkList (map mkString layouts)},
          modkey: ${mkString modkey},
          mousekey: ${mkString mousekey},
          tags: ${mkList (map mkString tags)},
          window_rules: ${mkList (map mkWindowRule windowRules)},
          workspaces: [],
      )
    '';
  mkTheme =
    {
      borderWidth ? null,
      defaultBorderColor ? null,
      floatingBorderColor ? null,
      focusedBorderColor ? null,
      gutterTop ? null,
      gutterRight ? null,
      gutterBottom ? null,
      gutterLeft ? null,
      margin ? null,
      workspaceMargin ? null,
    }:
    ''
      #![enable(implicit_some)]
      (
          border_width: ${optInt borderWidth},
          default_border_color: ${optString defaultBorderColor},
          floating_border_color: ${optString floatingBorderColor},
          focused_border_color: ${optString focusedBorderColor},
          margin: ${optInt margin},
          workpace_magin: ${optInt workspaceMargin},
          gutter: [
              (side: Top, value: ${optInt gutterTop},),
              (side: Right, value: ${optInt gutterRight},),
              (side: Bottom, value: ${optInt gutterBottom},),
              (side: Left, value: ${optInt gutterLeft},),
          ],
      )
    '';
in
{
  inherit mkConfig mkTheme;
  keybind = {
    mod = {
      ctrl_alt = [
        "Control"
        "Alt"
      ];
      empty = [ ];
      win = [ "modkey" ];
      win_ctrl = [
        "modkey"
        "Control"
      ];
      win_shift = [
        "modkey"
        "Shift"
      ];
    };
    mkExecute = mkKeybind "Execute";
    mkSoftReload = modifier: key: (mkKeybind "SoftReload" modifier key "");
    mkFocusNextTag = mkKeybind "FocusNextTag";
    mkFocusPreviousTag = mkKeybind "FocusPreviousTag";
    mkFocusWorkspaceNext = modifier: key: (mkKeybind "FocusWorkspaceNext" modifier key "");
    mkFocusWorkspacePrevious = modifier: key: (mkKeybind "FocusWorkspacePrevious" modifier key "");
    mkMoveToLastWorkspace = modifier: key: (mkKeybind "MoveToLastWorkspace" modifier key "");
    mkGotoTag = mkKeybind "GotoTag";
    mkMoveToTag = mkKeybind "MoveToTag";
    mkSwapTags = modifier: key: (mkKeybind "SwapTags" modifier key "");
    mkNextLayout = modifier: key: (mkKeybind "NextLayout" modifier key "");
    mkPreviousLayout = modifier: key: (mkKeybind "PreviousLayout" modifier key "");
    mkCloseWindow = modifier: key: (mkKeybind "CloseWindow" modifier key "");
    mkFocusWindowDown = modifier: key: (mkKeybind "FocusWindowDown" modifier key "");
    mkFocusWindowUp = modifier: key: (mkKeybind "FocusWindowUp" modifier key "");
    mkMoveWindowDown = modifier: key: (mkKeybind "MoveWindowDown" modifier key "");
    mkMoveWindowTop = modifier: key: (mkKeybind "MoveWindowTop" modifier key "");
    mkMoveWindowUp = modifier: key: (mkKeybind "MoveWindowUp" modifier key "");
    mkToggleFloating = modifier: key: (mkKeybind "ToggleFloating" modifier key "");
    mkToggleFullScreen = modifier: key: (mkKeybind "ToggleFullScreen" modifier key "");
    mkToggleSticky = modifier: key: (mkKeybind "ToggleSticky" modifier key "");
  };
}
