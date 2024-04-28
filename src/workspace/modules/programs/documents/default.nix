{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      pkgs.libreoffice
      pkgs.obsidian
    ];
    programs.zathura = {
      enable = true;
      extraConfig = ''
        include catppuccin
      '';
    };
    xdg = {
      configFile."zathura/catppuccin".source = ./resources/zathura/catppuccin;
      mimeApps.defaultApplications =
        let
          defaults = [ "org.pwmt.zathura.desktop" ];
        in
        {
          "application/epub+zip" = defaults;
          "application/pdf" = defaults;
          "image/vnd.djvu" = defaults;
          "image/x-djvu" = defaults;
          "text/fb2+xml" = defaults;
        };
    };
  };
}
