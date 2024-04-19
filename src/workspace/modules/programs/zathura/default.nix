{ config, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        include catppuccin
      '';
    };
    xdg = {
      configFile."zathura/catppuccin".source = ./resources/catppuccin;
    };
  };
}
