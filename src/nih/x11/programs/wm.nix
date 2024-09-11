{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  cfgX11 = cfg.x11;
  package = pkgs.leftwm;
  executable = "${package}/bin/leftwm";
in
{
  options.nih.x11.wm = {
    gutterSize = lib.mkOption { type = lib.types.int; };
    marginSize = lib.mkOption { type = lib.types.int; };
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
    executable = lib.mkOption {
      type = lib.types.str;
      default = executable;
    };
    commands = {
      reload = lib.mkOption {
        type = lib.types.str;
        default = "${executable} command SoftReload";
      };
    };
    windowRules = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih = {
      services.dunst =
        let
          gutter = cfgX11.wm.gutterSize;
        in
        {
          gap = gutter;
          offset = gutter * 2;
        };
      user.home.file =
        let
          hsetroot = "${pkgs.hsetroot}/bin/hsetroot";
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
            keybind =
              let
                kb = lib.nih.leftwm.keybind;
                mod = kb.mod;
                tags = map builtins.toString (lib.range 1 7);
              in
              [
                (kb.mkExecute mod.win "r" cfgX11.programs.rlaunchx.executable)
                (kb.mkExecute mod.empty "Print" "screenshot")
                (kb.mkExecute mod.win "Return" cfgPrograms.terminal.executable)
                (kb.mkExecute mod.ctrl_alt "End" "loginctl kill-session $XDG_SESSION_ID")
                (kb.mkExecute mod.ctrl_alt "g" "setxkbmap -layout us,ge -option grp:win_space_toggle")
                (kb.mkExecute mod.ctrl_alt "r" "setxkbmap -layout us,ru -option grp:win_space_toggle")
                (kb.mkExecute mod.ctrl_alt "s" "setxkbmap -layout us,sk -option grp:win_space_toggle")
                (kb.mkSoftReload mod.win_ctrl "r")
                (kb.mkFocusNextTag mod.win "Down" "ignore_empty")
                (kb.mkFocusPreviousTag mod.win "Up" "ignore_empty")
                (kb.mkFocusWorkspacePrevious mod.win_ctrl "Up")
                (kb.mkFocusWorkspaceNext mod.win_ctrl "Down")
                (kb.mkMoveToLastWorkspace mod.win_shift "w")
                (kb.mkSwapTags mod.win "w")
                (kb.mkNextLayout mod.win_ctrl "Right")
                (kb.mkPreviousLayout mod.win_ctrl "Left")
                (kb.mkCloseWindow mod.win_shift "q")
                (kb.mkFocusWindowDown mod.win "Right")
                (kb.mkFocusWindowUp mod.win "Left")
                (kb.mkMoveWindowDown mod.win_shift "Right")
                (kb.mkMoveWindowTop mod.win_shift "Return")
                (kb.mkMoveWindowUp mod.win_shift "Left")
                (kb.mkToggleFloating mod.win_shift "t")
                (kb.mkToggleFullScreen mod.win_shift "f")
                (kb.mkToggleSticky mod.win_shift "s")
              ]
              ++ (map (idx: kb.mkGotoTag mod.win idx idx) tags)
              ++ (map (idx: kb.mkMoveToTag mod.win_shift idx idx) tags);
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
            windowRules = cfgX11.wm.windowRules;
          };
          ".config/leftwm/down" = {
            executable = true;
            text = ''
              #!${nushell}

              ${executable} command 'UnloadTheme'
              ${hsetroot} -solid '#000000'
            '';
          };
          ".config/leftwm/up" = {
            executable = true;
            text = ''
              #!${nushell}

              ${executable} command $'LoadTheme ($env.HOME)/.config/leftwm/themes/current/theme.ron'
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
              colors = cfgStyle.palette.colors;
            in
            lib.nih.leftwm.mkTheme {
              borderWidth = 1;
              defaultBorderColor = colors.overlay2;
              floatingBorderColor = colors.overlay1;
              focusedBorderColor = colors.green;
              gutterTop = cfgX11.wm.gutterSize;
              gutterRight = cfgX11.wm.gutterSize;
              gutterBottom = cfgX11.wm.gutterSize;
              gutterLeft = cfgX11.wm.gutterSize;
              margin = cfgX11.wm.marginSize;
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
