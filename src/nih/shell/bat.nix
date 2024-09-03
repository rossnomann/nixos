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
  batThemeName = "Catppuccin ${lib.nih.strings.capitalize cfgPalette.variant}";
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bat ];
    system.userActivationScripts.batCache = ''
      echo "Rebuilding bat theme cache $XDG_CACHE_HOME"
      cd "${pkgs.emptyDirectory}"
      ${lib.getExe pkgs.bat} cache --build
    '';
    nih.user.home.file = {
      ".config/bat/config".text = ''
        --theme='${batThemeName}'
      '';
      ".config/bat/themes/${batThemeName}.tmTheme".source = "${npins.catppuccin-bat}/themes/${batThemeName}.tmTheme";
    };
  };
}
