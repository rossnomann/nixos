{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgServices = cfg.services;
  cfgStyle = cfg.style;
  package = pkgs.dunst;
in
{
  options.nih.services.dunst = {
    iconSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
    };
    gap = lib.mkOption {
      type = lib.types.int;
      default = 12;
    };
    offset = lib.mkOption {
      type = lib.types.int;
      default = 24;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      package
      pkgs.toastify
    ];
    services.dbus.packages = [ package ];
    systemd.packages = [ package ];
    systemd.user.units."dunst.service" = {
      overrideStrategy = "asDropin";
      text = ''
        [Unit]
        Requires=graphical-session.target
        After=graphical-session.target
      '';
    };
    nih.user.home.file =
      let
        colors = cfgStyle.palette.colors;
      in
      {
        ".config/dunst/dunstrc".text =
          let
            font = cfgStyle.fonts.sansSerif;
            iconTheme = cfgStyle.icons;
          in
          lib.nih.gen.dunst.mkConfig {
            background = colors.base;
            follow = "keyboard";
            font = "${font.family} ${builtins.toString font.defaultSize}";
            foreground = colors.text;
            frameColor = colors.green;
            frameColorCritical = colors.red;
            frameColorLow = colors.blue;
            frameWidth = 1;
            gapSize = cfgServices.dunst.gap;
            offsetX = cfgServices.dunst.offset;
            offsetY = cfgServices.dunst.offset;
            origin = "top-right";
            iconPath = lib.nih.gen.dunst.mkIconPath {
              themePackage = iconTheme.package;
              themeName = iconTheme.name;
              iconsSize =
                let
                  size = builtins.toString cfgServices.dunst.iconSize;
                in
                "${size}x${size}";
            };
          };
      };
  };
}
