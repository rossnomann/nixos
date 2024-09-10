{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
  package = pkgs.leftwm;
in
{
  options.nih.gui.x11.wm = {
    gutterSize = lib.mkOption { type = lib.types.int; };
    marginSize = lib.mkOption { type = lib.types.int; };
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
    windowRules = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih = {
      gui.services.dunst =
        let
          gutter = cfgGui.x11.wm.gutterSize;
        in
        {
          gap = gutter;
          offset = gutter * 2;
        };
      user.home.file =
        let
          hsetroot = "${pkgs.hsetroot}/bin/hsetroot";
          leftwm = "${package}/bin/leftwm";
          nushell = "${pkgs.nushell}/bin/nu";
          xsetroot = "${pkgs.xorg.xsetroot}/bin/xsetroot";
        in
        {
          ".config/leftwm/config.ron".text = lib.nih.leftwm.mkConfig {
            defaultHeight = 300;
            defaultWidth = 400;
            disableCurrentTagSwap = true;
            disableTitleDrag = true;
            disableWindowSnap = true;
            focusBehaviour = "Sloppy";
            focusNewWindows = true;
            insertBehaviour = "Bottom";
            sloppyMouseFollowsFocus = true;
            statePath = "None";
            keybind = [
              {
                command = "Execute";
                value = "rlaunchx";
                modifier = [ "modkey" ];
                key = "r";
              }
              {
                command = "Execute";
                value = "screenshot";
                modifier = [ ];
                key = "Print";
              }
              {
                command = "Execute";
                value = "alacritty";
                modifier = [ "modkey" ];
                key = "Return";
              }
              {
                command = "Execute";
                value = "loginctl kill-session $XDG_SESSION_ID";
                modifier = [
                  "Control"
                  "Alt"
                ];
                key = "End";
              }
              {
                command = "Execute";
                value = "setxkbmap -layout us,ge -option grp:win_space_toggle";
                modifier = [
                  "Control"
                  "Alt"
                ];
                key = "g";
              }
              {
                command = "Execute";
                value = "setxkbmap -layout us,ru -option grp:win_space_toggle";
                modifier = [
                  "Control"
                  "Alt"
                ];
                key = "r";
              }
              {
                command = "Execute";
                value = "setxkbmap -layout us,sk -option grp:win_space_toggle";
                modifier = [
                  "Control"
                  "Alt"
                ];
                key = "s";
              }

              {
                command = "SoftReload";
                value = "";
                modifier = [
                  "modkey"
                  "Control"
                ];
                key = "r";
              }

              {
                command = "FocusNextTag";
                value = "ignore_empty";
                modifier = [ "modkey" ];
                key = "Down";
              }
              {
                command = "FocusPreviousTag";
                value = "ignore_empty";
                modifier = [ "modkey" ];
                key = "Up";
              }
              {
                command = "FocusWorkspacePrevious";
                value = "";
                modifier = [
                  "modkey"
                  "Control"
                ];
                key = "Up";
              }
              {
                command = "FocusWorkspaceNext";
                value = "";
                modifier = [
                  "modkey"
                  "Control"
                ];
                key = "Down";
              }
              {
                command = "MoveToLastWorkspace";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "w";
              }

              {
                command = "GotoTag";
                value = "1";
                modifier = [ "modkey" ];
                key = "1";
              }
              {
                command = "GotoTag";
                value = "2";
                modifier = [ "modkey" ];
                key = "2";
              }
              {
                command = "GotoTag";
                value = "3";
                modifier = [ "modkey" ];
                key = "3";
              }
              {
                command = "GotoTag";
                value = "4";
                modifier = [ "modkey" ];
                key = "4";
              }
              {
                command = "GotoTag";
                value = "5";
                modifier = [ "modkey" ];
                key = "5";
              }
              {
                command = "GotoTag";
                value = "6";
                modifier = [ "modkey" ];
                key = "6";
              }
              {
                command = "GotoTag";
                value = "7";
                modifier = [ "modkey" ];
                key = "7";
              }
              {
                command = "MoveToTag";
                value = "1";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "1";
              }
              {
                command = "MoveToTag";
                value = "2";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "2";
              }
              {
                command = "MoveToTag";
                value = "3";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "3";
              }
              {
                command = "MoveToTag";
                value = "4";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "4";
              }
              {
                command = "MoveToTag";
                value = "5";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "5";
              }
              {
                command = "MoveToTag";
                value = "6";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "6";
              }
              {
                command = "MoveToTag";
                value = "7";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "7";
              }
              {
                command = "SwapTags";
                value = "";
                modifier = [ "modkey" ];
                key = "w";
              }

              {
                command = "NextLayout";
                value = "";
                modifier = [
                  "modkey"
                  "Control"
                ];
                key = "Right";
              }
              {
                command = "PreviousLayout";
                value = "";
                modifier = [
                  "modkey"
                  "Control"
                ];
                key = "Left";
              }

              {
                command = "CloseWindow";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "q";
              }
              {
                command = "FocusWindowUp";
                value = "";
                modifier = [ "modkey" ];
                key = "Left";
              }
              {
                command = "FocusWindowDown";
                value = "";
                modifier = [ "modkey" ];
                key = "Right";
              }
              {
                command = "MoveWindowDown";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "Down";
              }
              {
                command = "MoveWindowTop";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "Return";
              }
              {
                command = "MoveWindowUp";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "Up";
              }
              {
                command = "ToggleFullScreen";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "f";
              }
              {
                command = "ToggleFloating";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "t";
              }
              {
                command = "ToggleSticky";
                value = "";
                modifier = [
                  "modkey"
                  "Shift"
                ];
                key = "s";
              }
            ];
            layoutMode = "Tag";
            layouts = [
              "MainAndVertStack"
              "Monocle"
            ];
            modkey = "Mod4";
            mousekey = "Mod4";
            tags = [
              "alacritty"
              "main"
              "secondary"
              "audio"
              "graphics"
              "documents"
              "steam"
            ];
            windowRules = cfgGui.x11.wm.windowRules;
          };
          ".config/leftwm/down" = {
            executable = true;
            text = ''
              #!${nushell}

              ${leftwm} command 'UnloadTheme'
              ${hsetroot} -solid '#000000'
            '';
          };
          ".config/leftwm/up" = {
            executable = true;
            text = ''
              #!${nushell}

              ${leftwm} command $'LoadTheme ($env.HOME)/.config/leftwm/themes/current/theme.ron'
              ${hsetroot} -fill $'($env.HOME)/.local/share/backgrounds/default.jpg'
              ${xsetroot} -cursor_name left_ptr
            '';
          };
          ".config/leftwm/themes/current/down" = {
            executable = true;
            text = ''
              #!${nushell}
            '';
          };
          ".config/leftwm/themes/current/theme.ron".text =
            let
              palette = cfgPalette.current;
            in
            lib.nih.leftwm.mkTheme {
              borderWidth = 1;
              defaultBorderColor = palette.overlay2;
              floatingBorderColor = palette.overlay1;
              focusedBorderColor = palette.green;
              gutterTop = cfgGui.x11.wm.gutterSize;
              gutterRight = cfgGui.x11.wm.gutterSize;
              gutterBottom = cfgGui.x11.wm.gutterSize;
              gutterLeft = cfgGui.x11.wm.gutterSize;
              margin = cfgGui.x11.wm.marginSize;
              workspaceMargin = 0;
            };
          ".config/leftwm/themes/current/up" = {
            executable = true;
            text = ''
              #!${nushell}
            '';
          };
        };
    };
  };
}
