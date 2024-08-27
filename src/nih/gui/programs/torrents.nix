{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.transmission_4-gtk ];
    home-manager.users.${cfgUser.name} = {
      xdg = {
        dataFile = {
          "applications/transmission.dekstop".text = ''
            [Desktop Entry]
            Encoding=UTF-8
            Version=1.0
            Type=Application
            NoDisplay=true
            Exec=transmission-gtk %u
            Name=transmission-gtk
            Comment=Custom definition for transmission-gtk
          '';
        };
        mimeApps =
          let
            assoc = {
              "x-scheme-handler/magnet" = [ "transmission.desktop" ];
              "application/x-bittorrent" = [ "transmission.desktop" ];
            };
          in
          {
            associations.added = assoc;
            defaultApplications = assoc;
          };
      };
    };
  };
}
