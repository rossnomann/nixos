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
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libreoffice
      pkgs.obsidian
      pkgs.simple-scan
      pkgs.zathura
    ];
    nih = {
      user.home.file = {
        ".config/zathura/zathurarc".text = ''
          include ${npins.catppuccin-zathura}/src/catppuccin-${cfgPalette.variant}
        '';
      };
      xdg.mime.documents = "org.pwmt.zathura.desktop";
    };
  };
}
