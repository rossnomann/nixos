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
  pkgDunst = pkgs.dunst;
in
{
  options.nih.services = {
    dunst = {
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
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgDunst
      pkgs.toastify
    ];
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      colord.enable = true;
      dbus.packages = [ pkgDunst ];
      libinput.enable = true;
      printing = {
        enable = true;
        cups-pdf.enable = true;
      };
      saned.enable = true;
    };
    systemd.packages = [ pkgDunst ];
    systemd.user.units."batsignal.service" = {
      name = "batsignal.service";
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      text = ''
        [Service]
        ExecStart=${pkgs.batsignal}/bin/batsignal
        Restart=on-failure
        RestartSec=1
        Type=simple

        [Unit]
        After=graphical-session-pre.target
        Description=batsignal - battery monitor daemon
        PartOf=graphical-session.target
      '';
    };
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
            mkIconPath =
              let
                iconsCategories = [
                  "actions"
                  "animations"
                  "apps"
                  "categories"
                  "devices"
                  "emblems"
                  "emotes"
                  "filesystem"
                  "intl"
                  "legacy"
                  "mimetypes"
                  "places"
                  "status"
                  "stock"
                ];
              in
              {
                themePackage,
                themeName,
                iconsSize,
              }:
              lib.concatStringsSep ":" (
                map (
                  iconsCategory: "${themePackage}/share/icons/${themeName}/${iconsSize}/${iconsCategory}"
                ) iconsCategories
              );
            iconPath = mkIconPath {
              themePackage = iconTheme.package;
              themeName = iconTheme.name;
              iconsSize =
                let
                  size = toString cfgServices.dunst.iconSize;
                in
                "${size}x${size}";
            };
          in
          ''
            [global]
            background="${colors.base}"
            follow=keyboard
            font="${font.family} ${toString font.defaultSize}"
            foreground="${colors.text}"
            frame_color="${colors.green}"
            frame_width=1
            gap_size=${toString cfgServices.dunst.gap}
            offset="(${toString cfgServices.dunst.offset}, ${toString cfgServices.dunst.offset})"
            origin="top-right"
            icon_path="${iconPath}"
            [urgency_critical]
            frame_color="${colors.red}"
            [urgency_low]
            frame_color="${colors.blue}"
          '';
      };
  };
}
