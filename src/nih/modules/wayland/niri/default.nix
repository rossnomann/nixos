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
  package = pkgs.niri;
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
      package
      pkgs.xwayland-satellite
    ];
    services.dbus.packages = [ pkgs.nautilus ];
    services.displayManager.sessionPackages = [ package ];
    services.graphical-desktop.enable = true;
    systemd.packages = [ package ];
    systemd.user.units."swaybg.service" = {
      text = ''
        [Unit]
        PartOf=graphical-session.target
        After=graphical-session.target
        Requisite=graphical-session.target


        [Service]
        ExecStart=${pkgs.swaybg}/bin/swaybg -i ${cfgStyle.wallpaper}
        Restart=on-failure
      '';
      wantedBy = [ "niri.service" ];
    };
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
      ".config/niri/base.kdl".source = ./config.kdl;
      ".config/niri/config.kdl".text =
        let
          colors = cfgStyle.palette.colors;
        in
        (import ./config.nix {
          inherit lib colors;
          outputs = cfgWayland.niri.outputs;
          workspaces = [
            "terminal"
            "main"
            "secondary"
            "audio"
            "graphics"
            "documents"
          ];
          windowRules = cfgWindowRules;
          spawnAtStartup = cfgWayland.niri.spawnAtStartup;
          cmdTerminal = ''"${cfgPrograms.terminal.executable}"'';
          cmdLauncher = (lib.strings.concatStringsSep " " (map (x: ''"${x}"'') cfgPrograms.rofi.cmdShow));
          accentColor = lib.getAttr cfgStyle.palette.accent colors;
          xcursorTheme = cfgStyle.cursors.name;
          xcursorSize = cfgStyle.cursors.size;
        });
    };
  };
}
