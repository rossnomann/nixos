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
      x11.wm.windowRules = [
        {
          windowClass = "libreoffice";
          spawnOnTag = "documents";
        }
        {
          windowClass = "obsidian";
          spawnOnTag = "documents";
        }
        {
          windowClass = "org.pwmt.zathura";
          spawnOnTag = "documents";
        }
        {
          windowClass = "simple-scan";
          spawnOnTag = "documents";
        }
      ];
      xdg.mime.documents = "org.pwmt.zathura.desktop";
    };
  };
}
