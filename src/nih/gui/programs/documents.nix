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
    nih.xdg.mime.documents = "org.pwmt.zathura.desktop";
    home-manager.users.${cfgUser.name}.home.file = {
      ".config/zathura/zathurarc".text = ''
        include ${npins.catppuccin-zathura}/src/catppuccin-${cfgPalette.variant}
      '';
    };
  };
}
