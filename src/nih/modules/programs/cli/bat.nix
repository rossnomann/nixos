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
  package = pkgs.bat;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    system.userActivationScripts.batCache = ''
      echo "Rebuilding bat theme cache $XDG_CACHE_HOME"
      cd "${pkgs.emptyDirectory}"
      ${lib.getExe package} cache --build
    '';
    nih.user.home.file =
      let
        themeName = "Catppuccin ${lib.strings.toSentenceCase cfgStyle.palette.variant}";
      in
      {
        ".config/bat/config".text = ''
          --theme='${themeName}'
        '';
        ".config/bat/themes/${themeName}.tmTheme".source =
          "${cfgSources.catppuccin-bat}/themes/${themeName}.tmTheme";
      };
  };
}
