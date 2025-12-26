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
  imports = [ ./config.nix ];
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
  };
}
