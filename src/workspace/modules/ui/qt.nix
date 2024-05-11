{ config, ... }:
let
  qtTheme = config.workspace.ui.qtTheme;
in
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ qtTheme.kvantumTheme.package ];
    qt = {
      enable = true;
      platformTheme.name = qtTheme.platformThemeName;
      style.name = qtTheme.styleName;
    };
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      theme=${qtTheme.kvantumTheme.name}
    '';
  };
}
