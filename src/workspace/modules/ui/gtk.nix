{ config, ... }:
let
  ui = config.workspace.ui;
  extraCss = ''
    * {
      border-radius: 0 0 0 0;
      box-shadow: none;
    }
  '';
  extraConfig = {
    gtk-decoration-layout = ":";
  };
  font = ui.font.sansSerif;
  gtkTheme = ui.gtkTheme;
  homeDirectory = config.home-manager.users.${config.workspace.user.name}.home.homeDirectory;
  iconTheme = ui.iconTheme;
in
{
  home-manager.users.${config.workspace.user.name} = {
    gtk = {
      enable = true;
      font = {
        name = font.family;
        size = font.defaultSize;
      };
      gtk2.configLocation = "${homeDirectory}/.config/gtk-2.0/gtkrc";
      gtk3 = {
        inherit extraConfig;
        inherit extraCss;
      };
      gtk4 = {
        inherit extraConfig;
        inherit extraCss;
      };
      iconTheme = {
        name = iconTheme.name;
        package = iconTheme.package;
      };
      theme = {
        name = gtkTheme.name;
        package = gtkTheme.package;
      };
    };
  };
  programs.dconf.enable = true;
}
