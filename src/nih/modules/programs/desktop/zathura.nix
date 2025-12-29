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
    environment.systemPackages = [ pkgs.zathura ];
    nih.user.home.file = {
      ".config/zathura/zathurarc".text = ''
        include ${cfgSources.catppuccin-zathura}/src/catppuccin-${cfgStyle.palette.variant}
      '';
    };
    nih.graphicalSession.windowRules = [
      {
        appId = ''^org\\.pwmt\\.zathura'';
        workspace = "main";
      }
    ];
    nih.xdg.mime.documents = "org.pwmt.zathura.desktop";
  };
}
