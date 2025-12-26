{ config, lib, ... }:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  cfgGraphicalSession = cfg.graphicalSession;
  cfgWindowRules = cfg.windowRules;
  kdl = import ./kdl.nix lib;
in
{
  options.nih.graphicalSession.niri.config = lib.mkOption {
    type = lib.types.submodule {
      options = {
        outputs = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption { type = lib.types.str; };
                backdropColor = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                focusAtStartup = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                };
                mode = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                position = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        x = lib.mkOption { type = lib.types.int; };
                        y = lib.mkOption { type = lib.types.int; };
                      };
                    }
                  );
                  default = null;
                };
                scale = lib.mkOption {
                  type = lib.types.nullOr lib.types.float;
                  default = null;
                };
                hotCorners = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        enabled = lib.mkOption { type = lib.types.bool; };
                      };
                    }
                  );
                  default = {
                    enabled = false;
                  };
                };
              };
            }
          );
          default = [ ];
        };
        spawnAtStartup = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        workspaces = lib.mkOption {
          type = lib.types.submodule {
            options = builtins.listToAttrs (
              map (name: {
                inherit name;
                value = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        name = lib.mkOption {
                          type = lib.types.str;
                          default = name;
                        };
                        openOnOutput = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                        };
                      };
                    }
                  );
                  default = null;
                };
              }) lib.nih.workspaces
            );
          };
        };
      };
    };
  };
  config = {
    nih.user.home.file = {
      ".config/niri/binds.kdl".source = ./binds.kdl;
      ".config/niri/config.kdl".text =
        let
          c = cfgGraphicalSession.niri.config;
          colors = cfgStyle.palette.colors;
          accentColor = lib.getAttr cfgStyle.palette.accent colors;
        in
        kdl.mkConfig {
          inherit (c) workspaces spawnAtStartup outputs;
          includes = [ "binds.kdl" ];
          bindsSpawn = [
            [
              "Mod+Return"
              [ cfgPrograms.terminal.executable ]
            ]
            [
              "Mod+R"
              cfgPrograms.rofi.cmdShow
            ]
          ];
          bindsWorkspaces = lib.nih.workspaces;
          cursor = {
            xcursorTheme = cfgStyle.cursors.name;
            xcursorSize = cfgStyle.cursors.size;
          };
          environment = {
            "NIXOS_OZONE_WL" = "1";
            "QT_QPA_PLATFORM" = "wayland";
          };
          hotkeyOverlay.skipAtStartup = true;
          input = {
            focusFollowsMouse.maxScrollAmount = "10%";
            keyboard = {
              xkb = {
                layout = "us,ru,sk";
                options = "grp:win_space_toggle";
                variant = ",";
              };
              trackLayout = "global";
            };
            touchpad = {
              dwt = true;
              dwtp = true;
              middleEmulation = true;
              scrollMethod = "two-finger";
              tap = true;
            };
            warpMouseToFocus = true;
          };
          layout = {
            border = {
              activeColor = accentColor;
              inactiveColor = colors.overlay2;
              urgentColor = colors.mauve;
              width = 2;
            };
            centerFocusedColumn = "always";
            defaultColumnWidth = [
              "proportion"
              1.0
            ];
            focusRing.enabled = false;
            gaps = 8;
            insertHint.color = colors.blue;
            presetColumnWidths = [
              [
                "proportion"
                1.0
              ]
              [
                "proportion"
                0.5
              ]
            ];
            presetWindowHeights = [
              [
                "proportion"
                1.0
              ]
              [
                "proportion"
                0.5
              ]
            ];
            struts = {
              bottom = 0;
              top = 0;
              left = 0;
              right = 0;
            };
          };
          overview.backdropColor = colors.crust;
          recentWindows.enabled = false;
          screenshotPath = null;
          windowRules = (
            [
              { openMaximizedToEdges = true; }
              {
                matches.isActive = false;
                opacity = 0.95;
              }
              {
                matches.isFloating = true;
                shadow.enabled = true;
              }
              {
                matches.isWindowCastTarget = true;
                border = {
                  activeColor = colors.red;
                  inactiveColor = colors.pink;
                  urgentColor = colors.peach;
                  width = 2;
                };
              }
            ]
            ++ (map (x: {
              matches = {
                appId = x.appId;
                title = x.title;
              };
              openOnWorkspace = x.workspace;
              openFullscreen = x.fullscreen;
              openFloating = x.floating;
            }) cfgWindowRules)
          );
        };
    };
  };
}
