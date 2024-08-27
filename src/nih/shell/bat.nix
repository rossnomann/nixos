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
    environment.systemPackages = [ pkgs.bat ];
    system.userActivationScripts.batCache = ''
      echo "Rebuilding bat theme cache $XDG_CACHE_HOME"
      cd "${pkgs.emptyDirectory}"
      ${lib.getExe pkgs.bat} cache --build
    '';
    home-manager.users.${cfgUser.name} =
      let
        themeName = "Catppuccin ${lib.nih.capStr cfgPalette.variant}";
      in
      {
        xdg.configFile = {
          "bat/config".text = ''
            --theme='${themeName}'
          '';
          "bat/themes/${themeName}.tmTheme".source = "${npins.catppuccin-bat}/themes/${themeName}.tmTheme";
        };
      };
  };
}
