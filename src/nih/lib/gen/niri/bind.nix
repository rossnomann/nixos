lib: kdl: props:
let
  formatKey = a: b: lib.strings.concatStringsSep "+" (a ++ [ b ]);
  formatSpawnCommand = command: lib.strings.concatStringsSep " " (map (x: "\"${x}\"") command);
  keysym = {
    alt = "Alt";
    alt_gr = "ISO_Level3_Shift";
    ctrl = "Ctrl";
    shift = "Shift";
    super = "Super";
  };
  mkBind =
    actionName:
    {
      actionArguments ? null,
      actionParameters ? null,
    }:
    {
      key,
      cooldown ? null,
      repeat ? null,
    }:
    (kdl.mkNode key {
      props = [
        (props.mkFloat "cooldown-ms" cooldown)
        (props.mkBool "repeat" repeat)
      ];
      children = [
        (kdl.mkNode actionName {
          args = actionArguments;
          props = actionParameters;
        })
      ];
    });
in
{
  mk = binds: kdl.mkNode "binds" { children = binds; };
  mkCenterColumn = ((mkBind "center-column") { });
  mkCloseWindow = ((mkBind "close-window") { });
  mkConsumeOrExpelWindowLeft = ((mkBind "consume-or-expel-window-left") { });
  mkConsumeOrExpelWindowRight = mkBind "consume-or-expel-window-right" { };
  mkConsumeWindowIntoColumn = mkBind "consume-window-into-column" { };
  mkDoScreenTransition =
    {
      key,
      cooldown ? null,
      repeat ? null,
      delay ? null,
    }:
    mkBind "do-screen-transition"
      {
        actionParameters = [
          [
            "delay-ms"
            (kdl.primitives.mkFloat delay)
          ]
        ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkDebugToggleOpaqueRegions = mkBind "debug-toggle-opaque-regions" { };
  mkDebugToggleDamage = mkBind "debug-toggle-damage" { };
  mkExpelWindowFromColumn = mkBind "expel-window-from-column" { };
  mkFocusColumnFirst = mkBind "focus-column-first" { };
  mkFocusColumnLast = mkBind "focus-column-last" { };
  mkFocusColumnLeft = mkBind "focus-column-left" { };
  mkFocusColumnLeftOrLast = mkBind "focus-column-left-or-last" { };
  mkFocusColumnOrMonitorLeft = mkBind "focus-column-or-monitor-left" { };
  mkFocusColumnOrMonitorRight = mkBind "focus-column-or-monitor-right" { };
  mkFocusColumnRight = mkBind "focus-column-right" { };
  mkFocusColumnRightOrFirst = mkBind "focus-column-right-or-first" { };
  mkFocusMonitorDown = mkBind "focus-monitor-down" { };
  mkFocusMonitorLeft = mkBind "focus-monitor-left" { };
  mkFocusMonitorRight = mkBind "focus-monitor-right" { };
  mkFocusMonitorUp = mkBind "focus-monitor-up" { };
  mkFocusWindowDown = mkBind "focus-window-down" { };
  mkFocusWindowDownOrColumnLeft = mkBind "focus-window-down-or-column-left" { };
  mkFocusWindowDownOrColumnRight = mkBind "focus-window-down-or-column-right" { };
  mkFocusWindowOrMonitorDown = mkBind "focus-window-or-monitor-down" { };
  mkFocusWindowOrMonitorUp = mkBind "focus-window-or-monitor-up" { };
  mkFocusWindowOrWorkspaceDown = mkBind "focus-window-or-workspace-down" { };
  mkFocusWindowOrWorkspaceUp = mkBind "focus-window-or-workspace-up" { };
  mkFocusWindowUp = mkBind "focus-window-up" { };
  mkFocusWindowUpOrColumnLeft = mkBind "focus-window-up-or-column-left" { };
  mkFocusWindowUpOrColumnRight = mkBind "focus-window-up-or-column-right" { };
  mkFocusWorkspace =
    {
      key,
      reference,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "focus-workspace"
      {
        actionArguments = [
          (kdl.primitives.mkString reference)
        ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkFocusWorkspaceDown = mkBind "focus-workspace-down" { };
  mkFocusWorkspacePrevious = mkBind "focus-workspace-previous" { };
  mkFocusWorkspaceUp = mkBind "focus-workspace-up" { };
  mkFullscreenWindow = mkBind "fullscreen-window" { };
  mkMaximizeColumn = mkBind "maximize-column" { };
  mkMoveColumnLeft = mkBind "move-column-left" { };
  mkMoveColumnLeftOrToMonitorLeft = mkBind "move-column-left-or-to-monitor-left" { };
  mkMoveColumnRight = mkBind "move-column-right" { };
  mkMoveColumnRightOrToMonitorRight = mkBind "move-column-right-or-to-monitor-right" { };
  mkMoveColumnToFirst = mkBind "move-column-to-first" { };
  mkMoveColumnToLast = mkBind "move-column-to-last" { };
  mkMoveColumnToMonitorDown = mkBind "move-column-to-monitor-down" { };
  mkMoveColumnToMonitorUp = mkBind "move-column-to-monitor-up" { };
  mkMoveColumnToMonitorLeft = mkBind "move-column-to-monitor-left" { };
  mkMoveColumnToMonitorRight = mkBind "move-column-to-monitor-right" { };
  mkMoveColumnToWorkspace =
    {
      key,
      reference,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "move-column-to-workspace"
      {
        actionArguments = [ (kdl.primitives.mkString reference) ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkMoveColumnToWorkspaceDown = mkBind "move-column-to-workspace-down" { };
  mkMoveColumnToWorkspaceUp = mkBind "move-column-to-workspace-up" { };
  mkMoveWindowDown = mkBind "move-window-down" { };
  mkMoveWindowDownOrToWorkspaceDown = mkBind "move-window-down-or-to-workspace-down" { };
  mkMoveWindowToMonitorDown = mkBind "move-window-to-monitor-down" { };
  mkMoveWindowToMonitorLeft = mkBind "move-window-to-monitor-left" { };
  mkMoveWindowToMonitorRight = mkBind "move-window-to-monitor-right" { };
  mkMoveWindowToMonitorUp = mkBind "move-window-to-monitor-up" { };
  mkMoveWindowToWorkspace =
    {
      key,
      reference,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "move-window-to-workspace"
      {
        actionArguments = [ (kdl.primitives.mkString reference) ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkMoveWindowToWorkspaceDown = mkBind "move-window-to-workspace-down" { };
  mkMoveWindowToWorkspaceUp = mkBind "move-window-to-workspace-up" { };
  mkMoveWindowUp = mkBind "move-window-up" { };
  mkMoveWindowUpOrToWorkspaceUp = mkBind "move-window-up-or-to-workspace-up" { };
  mkMoveWorkspaceDown = mkBind "move-workspace-down" { };
  mkMoveWorkspaceToMonitorDown = mkBind "move-workspace-to-monitor-down" { };
  mkMoveWorkspaceToMonitorLeft = mkBind "move-workspace-to-monitor-left" { };
  mkMoveWorkspaceToMonitorRight = mkBind "move-workspace-to-monitor-right" { };
  mkMoveWorkspaceToMonitorUp = mkBind "move-workspace-to-monitor-up" { };
  mkMoveWorkspaceUp = mkBind "move-workspace-up" { };
  mkPowerOffMonitors = ((mkBind "power-off-monitors") { });
  mkQuit =
    {
      key,
      skipConfirmation ? false,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "quit"
      {
        actionParameters = [
          [
            "skip-confirmation"
            (lib.boolToString skipConfirmation)
          ]
        ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkResetWindowHeight = mkBind "reset-window-height" { };
  mkScreenshot = mkBind "screenshot" { };
  mkScreenshotScreen = mkBind "screenshot-screen" { };
  mkScreenshotWindow = mkBind "screenshot-window" { };
  mkSetColumnWidth =
    {
      key,
      sizeChange,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "set-column-width"
      {
        actionArguments = [ (kdl.primitives.mkString sizeChange) ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkSetWindowHeight =
    {
      key,
      sizeChange,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "set-window-height"
      {
        actionArguments = [ (kdl.primitives.mkString sizeChange) ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mkShowHotkeyOverlay = mkBind "show-hotkey-overlay" { };
  mkSwitchLayoutNext = mkBind "switch-layout" {
    actionArguments = [ (kdl.primitives.mkString "next") ];
  };
  mkSwitchLayoutPrev = mkBind "switch-layout" {
    actionArguments = [ (kdl.primitives.mkString "prev") ];
  };
  mkSwitchPresetColumnWidth = mkBind "switch-preset-column-width" { };
  mkToggleDebugTint = mkBind "toggle-debug-tint" { };
  mkSpawn =
    {
      key,
      command,
      cooldown ? null,
      repeat ? null,
    }:
    mkBind "spawn"
      {
        actionArguments = [ (formatSpawnCommand command) ];
      }
      {
        inherit
          key
          cooldown
          repeat
          ;
      };
  mod =
    let
      print = "Print";
    in
    {
      inherit print;
      altPrint = formatKey [ keysym.alt ] print;
      ctrlPrint = formatKey [ keysym.ctrl ] print;
      super = formatKey [ keysym.super ];
      superCtrl = formatKey [
        keysym.super
        keysym.ctrl
      ];
      superAlt = formatKey [
        keysym.super
        keysym.alt
      ];
      superShift = formatKey [
        keysym.super
        keysym.shift
      ];
      ctrlAlt = formatKey [
        keysym.ctrl
        keysym.alt
      ];
    };
  scroll = {
    wheel = {
      down = "WheelScrollDown";
      left = "WheelScrollLeft";
      right = "WheelScrollRight";
      up = "WheelScrollUp";
    };
    touchpad = {
      down = "TouchpadScrollDown";
      left = "TouchpadScrollLeft";
      right = "TouchpadScrollRight";
      up = "TouchpadScrollUp";
    };
  };
}
