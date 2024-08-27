{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libreoffice
      pkgs.obsidian
      pkgs.simple-scan
      pkgs.zathura
    ];
    home-manager.users.${cfgUser.name} = {
      xdg = {
        configFile = {
          "zathura/zathurarc".text = ''
            include catppuccin
          '';
          "zathura/catppuccin".source = "${npins.catppuccin-zathura}/src/catppuccin-${cfgPalette.variant}";
        };
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
  };
}
