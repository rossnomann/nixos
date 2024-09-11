{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUi = cfg.ui;
  package = pkgs.dunst;
in
{
  options.nih.ui.services.dunst = {
    iconSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
    };
    gap = lib.mkOption { type = lib.types.int; };
    offset = lib.mkOption { type = lib.types.int; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      package
      pkgs.toastify
    ];
    systemd.user.units."dunst.service" = {
      name = "dunst.service";
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      text = ''
        [Service]
        BusName=org.freedesktop.Notifications
        Environment=
        ExecStart='${package}/bin/dunst'
        Type=dbus

        [Unit]
        After=graphical-session-pre.target
        Description=Dunst notification daemon
        PartOf=graphical-session.target
      '';
    };
    nih.user.home.file =
      let
        colors = cfgPalette.colors;
        dbusServicePath = "${package}/share/dbus-1/services/org.knopwob.dunst.service";
      in
      {
        ".config/dunst/dunstrc".text =
          let
            font = cfgUi.style.fonts.sansSerif;
            fontName = "${font.family} ${builtins.toString font.defaultSize}";
            dunst = cfgUi.services.dunst;
            gap = builtins.toString dunst.gap;
            offset = builtins.toString dunst.offset;
            iconTheme = cfgUi.style.icons;
            iconPath = lib.nih.paths.mkIconPath {
              themePackage = iconTheme.package;
              themeName = iconTheme.name;
              iconsSize =
                let
                  size = builtins.toString dunst.iconSize;
                in
                "${size}x${size}";
            };
          in
          ''
            [global]
            background="${colors.base}"
            follow="keyboard"
            font="${fontName}"
            foreground="${colors.text}"
            frame_color="${colors.green}"
            frame_width=1
            gap_size=${gap}
            offset="${offset}x${offset}"
            origin="top-right"
            icon_path="${iconPath}"
            [urgency_critical]
            frame_color="${colors.red}"
            [urgency_low]
            frame_color="${colors.blue}"
          '';
        ".local/share/dbus-1/services/org.knopwob.dunst.service".source = dbusServicePath;
      };
  };
}
