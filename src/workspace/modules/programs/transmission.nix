{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.transmission-gtk ];
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
}
