{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  package = pkgs.niri;
in
{
  imports = [ ./config.nix ];
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      GTK_USE_PORTAL = 1;
    };
    environment.systemPackages = [
      package
      pkgs.wl-clipboard-rs
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
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
