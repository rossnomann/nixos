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
  cfgUser = cfg.user;
  cfgWayland = cfg.wayland;
  cfgWindowRules = cfg.windowRules;
in
{
  options.nih.wayland.compositor = {
    executable = lib.mkOption { type = lib.types.str; };
    package = lib.mkOption { type = lib.types.package; };
    spawnAtStartup = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.enable) {
    environment.systemPackages = [ cfgWayland.compositor.package ];
    xdg.portal.configPackages = [ cfgWayland.compositor.package ];
    nih.login.command = "'${cfgUser.home.file.".config/sw/swrc".source}'";
    nih.user.home.file = {
      ".config/sw/swrc" = {
        executable = true;
        text =
          let
            compositor = cfgWayland.compositor.executable;
          in
          ''
            #!/usr/bin/env bash
            if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
                eval $(dbus-launch --exit-with-session --sh-syntax)
            fi
            systemctl --user start wm-session.target
            exec ${compositor} --session
          '';
      };
      ".config/niri/config.kdl".text =
        let
          niri = lib.nih.gen.niri;
          colors = cfgStyle.palette.colors;
          accentColor = lib.getAttr cfgStyle.palette.accent colors;
          workspaces = [
            "alacritty"
            "main"
            "secondary"
            "audio"
            "graphics"
            "documents"
          ];
          workspacesIndexed =
            let
              indexes = map builtins.toString (lib.range 1 (lib.lists.length workspaces));
            in
            lib.lists.zipListsWith (a: b: {
              idx = a;
              name = b;
            }) indexes workspaces;
        in
        niri.mkConfig {
          binds =
            let
              bind = niri.bind;
            in
            [
              (bind.mkQuit { key = bind.mod.ctrlAlt "End"; })
              (bind.mkPowerOffMonitors { key = bind.mod.ctrlAlt "O"; })

              (bind.mkSpawn {
                key = bind.mod.super "Return";
                command = [ cfgPrograms.terminal.executable ];
              })
              (bind.mkSpawn {
                key = bind.mod.super "R";
                command = [ cfgWayland.programs.kickoff.executable ];
              })

              (bind.mkCenterColumn { key = bind.mod.super "C"; })
              (bind.mkFocusColumnFirst { key = bind.mod.super "Home"; })
              (bind.mkFocusColumnLast { key = bind.mod.super "End"; })
              (bind.mkFocusColumnLeft { key = bind.mod.super "Left"; })
              (bind.mkFocusColumnRight { key = bind.mod.super "Right"; })
              (bind.mkFocusWindowDown { key = bind.mod.super "Down"; })
              (bind.mkFocusWindowUp { key = bind.mod.super "Up"; })
              (bind.mkMaximizeColumn { key = bind.mod.super "M"; })
              (bind.mkMoveColumnLeft { key = bind.mod.super "H"; })
              (bind.mkMoveColumnRight { key = bind.mod.super "J"; })
              (bind.mkMoveColumnToFirst { key = bind.mod.super "K"; })
              (bind.mkMoveColumnToLast { key = bind.mod.super "L"; })
              (bind.mkSetColumnWidth {
                key = bind.mod.super "Minus";
                sizeChange = "-10%";
              })
              (bind.mkSetColumnWidth {
                key = bind.mod.super "Equal";
                sizeChange = "+10%";
              })
              (bind.mkSwitchPresetColumnWidth { key = bind.mod.super "W"; })

              (bind.mkFocusWorkspaceDown { key = bind.mod.superCtrl "Down"; })
              (bind.mkFocusWorkspacePrevious { key = bind.mod.superCtrl "W"; })
              (bind.mkFocusWorkspaceUp { key = bind.mod.superCtrl "Up"; })
              (bind.mkSwitchLayoutNext { key = bind.mod.superCtrl "Left"; })
              (bind.mkSwitchLayoutPrev { key = bind.mod.superCtrl "Right"; })

              (bind.mkCloseWindow { key = bind.mod.superShift "Q"; })
              (bind.mkConsumeWindowIntoColumn { key = bind.mod.superShift "Z"; })
              (bind.mkExpelWindowFromColumn { key = bind.mod.superShift "X"; })
              (bind.mkFullscreenWindow { key = bind.mod.superShift "F"; })

              (bind.mkMoveWindowDown { key = bind.mod.superShift "Down"; })
              (bind.mkMoveWindowUp { key = bind.mod.superShift "Up"; })
              (bind.mkResetWindowHeight { key = bind.mod.superShift "R"; })
              (bind.mkSetWindowHeight {
                key = bind.mod.superShift "Minus";
                sizeChange = "-10%";
              })
              (bind.mkSetWindowHeight {
                key = bind.mod.superShift "Equal";
                sizeChange = "+10%";
              })

              (bind.mkScreenshot { key = bind.mod.print; })
              (bind.mkScreenshotScreen { key = bind.mod.ctrlPrint; })
              (bind.mkScreenshotWindow { key = bind.mod.altPrint; })
            ]
            ++ (map (
              item:
              bind.mkFocusWorkspace {
                key = bind.mod.super item.idx;
                reference = item.name;
              }
            ) workspacesIndexed)
            ++ (map (
              item:
              bind.mkMoveWindowToWorkspace {
                key = bind.mod.superShift item.idx;
                reference = item.name;
              }
            ) workspacesIndexed);
          animation.off = false;
          cursor = {
            theme = cfgStyle.cursors.name;
            size = cfgStyle.cursors.size;
          };
          environment =
            let
              mkVar = niri.environment.mkVar;
            in
            [
              (mkVar "NIXOS_OZONE_WL" "1")
              (mkVar "QT_QPA_PLATFORM" "wayland")
            ];
          preferNoCsd = true;
          screenshotPath = null;
          hotkeyOverlay.skipAtStartup = true;
          input = {
            keyboard = {
              xkb = {
                layout = "us,ru";
                options = "grp:win_space_toggle";
                variant = "qwerty";
              };
              trackLayout = "global";
            };
            touchpad = {
              accelSpeed = null;
              accelProfile = null;
              clickMethod = null;
              disabledOnExternalMouse = false;
              dwt = true;
              dwtp = true;
              leftHanded = false;
              middleEmulation = true;
              naturalScroll = false;
              off = false;
              scrollMethod = "two-finger";
              tap = true;
              tapButtonMap = null;
            };
            warpMouseToFocus = true;
          };
          layout = {
            border = {
              activeColor = accentColor;
              inactiveColor = colors.overlay2;
              off = false;
              width = 2;
            };
            centerFocusedColumn = "on-overflow";
            defaultColumnWidth = niri.layout.mkPresetProportion 1.0;
            focusRing.off = true;
            gaps = 4;
            presetColumnWidths = [
              (niri.layout.mkPresetProportion 1.0)
              (niri.layout.mkPresetProportion 0.6)
              (niri.layout.mkPresetProportion 0.5)
              (niri.layout.mkPresetProportion 0.3)
            ];
            struts = {
              bottom = 0;
              top = 0;
              left = 0;
              right = 0;
            };
          };
          spawnAtStartup = cfgWayland.compositor.spawnAtStartup;
          windowRules = (
            map (x: {
              matches = [
                {
                  appId = x.waylandAppId;
                  title = x.title;
                }
              ];
              openFullscreen = x.useFullscreen;
              openOnWorkspace = x.useWorkspace;
            }) cfgWindowRules
          );
          workspaces = (map (x: { name = x; }) workspaces);
        };
    };
    nih.wayland.compositor.executable = "${cfgWayland.compositor.package}/bin/niri";
    nih.wayland.compositor.package = pkgs.niri;
    xdg.portal = {
      enable = true;
      config.common.default = [ "gnome" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
  };
}
