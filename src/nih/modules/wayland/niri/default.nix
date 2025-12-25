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
  cfgWayland = cfg.wayland;
  cfgWindowRules = cfg.windowRules;
  pkgNiri = pkgs.niri;
  niri = import ./generators.nix { inherit lib; };
in
{
  options.nih.wayland.niri = {
    spawnAtStartup = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    outputs = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.enable) {
    environment.systemPackages = [
      pkgNiri
      pkgs.xwayland-satellite
    ];
    services.dbus.packages = [ pkgs.nautilus ];
    services.displayManager.sessionPackages = [ pkgNiri ];
    services.gnome.gnome-keyring.enable = true;
    services.graphical-desktop.enable = true;
    systemd.packages = [ pkgNiri ];
    xdg.portal = {
      enable = true;
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    nih.user.home.file = {
      ".config/niri/base.kdl".source = ./base.kdl;
      ".config/niri/config.kdl".text =
        let
          colors = cfgStyle.palette.colors;
          accentColor = lib.getAttr cfgStyle.palette.accent colors;
          workspaces = [
            "terminal"
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
        ''
          include "base.kdl"

          binds {
            ${niri.mkBindSpawn "Mod+Return" ''"${cfgPrograms.terminal.executable}"''}
            ${niri.mkBindSpawn "Mod+R" (
              lib.strings.concatStringsSep " " (map (x: ''"${x}"'') cfgPrograms.rofi.cmdShow)
            )}
            ${niri.mkBindsWorkspaces workspacesIndexed}
          }

          cursor {
            xcursor-theme "${cfgStyle.cursors.name}"
            xcursor-size ${builtins.toString cfgStyle.cursors.size}
          }

          layout {
            border {
              active-color "${accentColor}"
              inactive-color "${colors.overlay2}"
              width 2
            }

            insert-hint { color "${colors.blue}"; }
          }

          overview { backdrop-color "${colors.crust}"; }

          recent-windows { off; }

          ${niri.mkOutputs cfgWayland.niri.outputs colors.crust}

          ${niri.mkSpawnAtStartup cfgWayland.niri.spawnAtStartup}

          ${niri.mkWindowRules cfgWindowRules}

          ${niri.mkWorkspaces workspaces}
        '';
    };
    nih.wayland.niri.spawnAtStartup = [
      ''"${pkgs.swaybg}/bin/swaybg" "-i" "${cfgStyle.wallpaper}"''
    ];
  };
}
