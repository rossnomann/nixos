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
    home-manager.users.${cfgUser.name} = {
      xdg.configFile = {
        "zathura/zathurarc".text = ''
          include catppuccin
        '';
        "zathura/catppuccin".source = "${npins.catppuccin-zathura}/src/catppuccin-${cfgPalette.variant}";
      };
    };
  };
}
