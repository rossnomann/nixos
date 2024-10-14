{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  options.nih.programs.cli.bat = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
    themeName = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.bat.package ];
    nih.programs.cli.bat.executable = lib.getExe pkgs.bat;
    nih.programs.cli.bat.package = pkgs.bat;
    nih.programs.cli.bat.themeName = "Catppuccin ${lib.nih.strings.capitalize cfgStyle.palette.variant}";
    system.userActivationScripts.batCache = ''
      echo "Rebuilding bat theme cache $XDG_CACHE_HOME"
      cd "${pkgs.emptyDirectory}"
      ${cfgPrograms.cli.bat.executable} cache --build
    '';
    nih.user.home.file =
      let
        themeName = cfgPrograms.cli.bat.themeName;
      in
      {
        ".config/bat/config".text = ''
          --theme='${themeName}'
        '';
        ".config/bat/themes/${themeName}.tmTheme".source = "${cfgSources.catppuccin-bat}/themes/${themeName}.tmTheme";
      };
  };
}
