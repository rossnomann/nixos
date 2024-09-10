{ lib }:
let
  mkList = items: "[${lib.strings.concatStringsSep ", " items}]";
  mkString = value: "\"${value}\"";
  optBool = value: if value == null then "None" else lib.boolToString value;
  optInt = value: if value == null then "None" else builtins.toString value;
  optString = value: if value == null then "None" else mkString value;
  optValue = value: if value == null then "None" else value;
  mkKeybind =
    {
      command,
      value,
      modifier,
      key,
    }:
    ''
      (
        command: ${command},
        value: ${mkString value},
        modifier: ${mkList (map mkString modifier)},
        key: ${mkString key}
      )
    '';
  mkWindowRule =
    {
      windowClass ? null,
      windowTitle ? null,
      spawnOnTag ? null,
      spawnAsType ? null,
      spawnSticky ? null,
      spawnFullscreen ? null,
      spawnFloating ? null,
    }:
    ''
      (
        spawn_as_type: ${optValue spawnAsType},
        spawn_floating: ${optBool spawnFloating},
        spawn_fullscreen: ${optBool spawnFullscreen},
        spawn_on_tag: ${optInt spawnOnTag},
        spawn_sticky: ${optBool spawnSticky},
        window_class: ${optString windowClass},
        window_title: ${optString windowTitle}
      )
    '';
in
{
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
          keybind: ${mkList (map mkKeybind keybind)},
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
}
