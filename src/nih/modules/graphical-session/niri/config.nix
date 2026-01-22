{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  cfgGraphicalSession = cfg.graphicalSession;
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
                        order = lib.mkOption {
                          type = lib.types.int;
                          default = -1;
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
  config = lib.mkIf cfg.enable {
    nih.user.home.file = {
      ".config/niri/binds.kdl".source = ./binds.kdl;
      ".config/niri/config.kdl".text =
        let
          c = cfgGraphicalSession.niri.config;
          colors = cfgStyle.palette.colors;
        in
        kdl.mkConfig {
          inherit (c) workspaces spawnAtStartup outputs;
          includes = [ "binds.kdl" ];
          animations = {
            enabled = true;
            slowdown = 0.5;
          };
          bindsSpawn = [
            [
              "Mod+Return"
              [ cfgPrograms.desktop.alacritty.executable ]
            ]
            [
              "Mod+R"
              cfgPrograms.desktop.rofi.cmdShow
            ]
            [
              "Mod+W"
              [ "niri-ws" ]
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
                layout = "fsk,ru";
                variant = ",";
              };
              trackLayout = "window";
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
              activeColor = cfgStyle.palette.accentColor;
              inactiveColor = colors.overlay2;
              urgentColor = colors.mauve;
              width = 2;
            };
            centerFocusedColumn = "never";
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
                0.75
              ]
              [
                "proportion"
                0.5
              ]
              [
                "proportion"
                0.25
              ]
            ];
            presetWindowHeights = [
              [
                "proportion"
                0.75
              ]
              [
                "proportion"
                0.5
              ]
              [
                "proportion"
                0.25
              ]
              [
                "proportion"
                1.0
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
              {
                clipToGeometry = true;
                drawBorderWithBackground = false;
              }
              {
                matches.isFloating = false;
                openMaximized = true;
                tiledState = true;
              }
              {
                matches.isActive = false;
                opacity = 0.95;
              }
              {
                matches.isFloating = true;
                maxHeight = 800;
                maxWidth = 1000;
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
            }) cfgGraphicalSession.windowRules)
          );
        };
    };
  };
}
