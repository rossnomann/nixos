{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.mc ];
    xdg = {
      configFile."mc/ini".source = ./resources/config.ini;
      configFile."mc/mc.ext.ini".source = ./resources/mc.ext.ini;
      dataFile."applications/mc.desktop".source = ./resources/mc.desktop;
      dataFile."mc/skins/catppuccin.ini".source = ./resources/catppuccin.ini;
      mimeApps.defaultApplications =
        let
          defaults = [ "mc.desktop" ];
        in
        {
          "inode/directory" = defaults;
        };
    };
  };
}
