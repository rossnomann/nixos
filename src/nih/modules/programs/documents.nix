{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libreoffice
      pkgs.obsidian
      pkgs.simple-scan
      pkgs.zathura
    ];
    nih.user.home.file = {
      ".config/zathura/zathurarc".text = ''
        include ${cfgSources.catppuccin-zathura}/src/catppuccin-${cfgStyle.palette.variant}
      '';
    };
    nih.windowRules = [
      {
        x11Class = "libreoffice";
        waylandAppId = "^libreoffice-.*";
        useWorkspace = "documents";
      }
      {
        x11Class = "obsidian";
        waylandAppId = "obsidian";
        useWorkspace = "documents";
      }
      {
        x11Class = "org.pwmt.zathura";
        waylandAppId = "org.pwmt.zathura";
        useWorkspace = "documents";
      }
      {
        x11Class = "simple-scan";
        waylandAppId = "simple-scan";
        useWorkspace = "documents";
      }
    ];
    nih.xdg.mime.documents = "org.pwmt.zathura.desktop";
  };
}
